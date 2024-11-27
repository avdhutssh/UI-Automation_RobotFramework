import json
import os


def customize_configuration_payload(title, new_value):
    # Construct relative path to the JSON file
    json_file_path = os.path.join('', '', 'abc.json')

    # Read the original JSON file
    with open(json_file_path, 'r') as file:
        data = json.load(file)

    # Find the rule with the matching title and modify the third value in parameters
    for rule in data['rules']:
        if rule['title'] == title:
            # Modify the third "value" in the "parameters" array and ensure it's a string
            if len(rule['parameters']) >= 3:
                rule['parameters'][2]['value'] = str(new_value)  # Convert value to string
                break
            else:
                raise ValueError(f"Rule '{title}' does not have a third parameter to modify.")
    
    return data  # Return full JSON data, modified


def specific_title_payload(title, new_value):
    # Get the modified payload using customize_configuration_payload
    modified_data = customize_configuration_payload(title, new_value)
    
    # Find and extract the rule with the matching title
    for rule in modified_data['rules']:
        if rule['title'] == title:
            specific_rule = {"rules": [rule]}  # Extract only this rule in a new dict
            return json.dumps(specific_rule, indent=4)
    
    raise ValueError(f"No rule found with title '{title}'.")

# # Test Example (if needed)
# if __name__ == "__main__":
#     specific_payload = specific_title_payload("Gateway high CPU usage", 70)
#     print(specific_payload)