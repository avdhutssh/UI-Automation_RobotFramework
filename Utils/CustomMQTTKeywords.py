import paho.mqtt.client as mqtt
from robot.api.deco import keyword
from datetime import datetime
import json
import time
import threading

BROKER_URI = ""
BROKER_PORT = 8883
USERNAME = ""
PASSWORD = ""
MQTT_TIMEOUT = 1800  # 30 minutes

# Function to connect to the MQTT Broker
def connect_to_mqtt_broker():
    """
    Connects to the MQTT broker and returns the client object.
    """
    client = mqtt.Client()
    client.username_pw_set(USERNAME, PASSWORD)
    client.tls_set()

    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected successfully.")
        else:
            print(f"Failed to connect, return code {rc}")

    client.on_connect = on_connect
    client.on_log = on_log  # Adding logging for debugging purposes

    try:
        client.connect(BROKER_URI, BROKER_PORT, 60)
        client.loop_start()
        time.sleep(5)  # Give some time to establish the connection
        return client
    except Exception as e:
        print(f"Exception occurred during connection: {str(e)}")
        raise

# Logging MQTT activities
def on_log(client, userdata, level, buf):
    """
    Logs MQTT client activities for debugging.
    """
    print(f"MQTT Log: {buf}")

# Subscribe to a specific topic
def subscribe_to_topic(client, topic):
    """
    Subscribes to a specified MQTT topic.
    """
    def on_subscribe(client, userdata, mid, granted_qos):
        print(f"Subscribed to topic {topic} with QoS {granted_qos}")

    client.on_subscribe = on_subscribe
    client.subscribe(topic)
    print(f"Subscribed to topic: {topic}")

@keyword("Get payload concurrently")
def get_payload_concurrently(client, *topics):
    """
    Gets the payload from multiple MQTT topics concurrently.
    :param client: The MQTT client instance.
    :param topics: List of topics to subscribe to and fetch the payloads from.
    :return: A dictionary of topic-payload pairs.
    """
    results = {}
    threads = []
    events = {}

    def on_message(client, userdata, message):
        topic = message.topic
        payload = message.payload.decode()
        print(f"Message received on topic {topic}: {payload}")
        try:
            results[topic] = json.loads(payload)
        except json.JSONDecodeError:
            results[topic] = payload
        events[topic].set()  # Set event to indicate message is received

    client.on_message = on_message

    # Subscribe to each topic and set event flags
    for topic in topics:
        client.subscribe(topic)
        event = threading.Event()
        events[topic] = event

    # Wait for all events (messages received) or timeout
    start_time = time.time()
    while any(not event.is_set() for event in events.values()):
        if time.time() - start_time > MQTT_TIMEOUT:
            print("Timeout reached while waiting for MQTT messages.")
            break
        time.sleep(1)

    # Disconnect the MQTT client after receiving the messages
    client.loop_stop()  # Stop the network loop
    client.disconnect()  # Disconnect from the broker
    print("Disconnected from MQTT broker")

    return results

# Example usage
def get_topic_payload(client, topic):
    """
    Gets the payload from a single topic (using the concurrent method).
    """
    return get_payload_concurrently(client, [topic])[topic]


def publish_to_State_topic(client, topic, device_id, connected):
    """
    Publishes a message to a specific MQTT topic with dynamic timestamps.
    
    :param client: The MQTT client instance.
    :param topic: The topic to publish the message to.
    :param device_id: The ID of the device.
    :param connected: The connection state of the device (True/False).
    """
    def on_publish(client, userdata, mid):
        print(f"Message published to topic {topic}")

    client.on_publish = on_publish

    current_time = datetime.utcnow().isoformat(timespec='milliseconds') + 'Z'
    last_handshake_time = (datetime.utcnow().replace(microsecond=0).isoformat()) + 'Z'

    message = {
        "type": "vpnchecker",
        "timeStamp": current_time,
        "data": {
            "lastHandshakeTime": last_handshake_time,
            "connected": connected,
            "deviceID": device_id
        }
    }

    try:
        client.publish(topic, json.dumps(message), qos=1)
        print(f"Published message to {topic}: {json.dumps(message)}")
    except Exception as e:
        print(f"Failed to publish message: {str(e)}")
