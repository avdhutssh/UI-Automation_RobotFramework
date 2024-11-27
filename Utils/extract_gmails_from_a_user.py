import imaplib
import email
import time
from robot.api.deco import keyword

def connect_to_gmail(user, password):
    imap_url = 'imap.gmail.com'
    try:
        print("Connecting to Gmail...")
        my_mail = imaplib.IMAP4_SSL(imap_url)
        print("Logging in...")
        my_mail.login(user, password)
        print("Login successful.")
        return my_mail
    except imaplib.IMAP4.error as e:
        raise Exception(f"IMAP error: {e}")

def fetch_latest_email(my_mail, sender, retries=6, delay=60):
    for attempt in range(retries):
        try:
            print("Selecting inbox...")
            my_mail.select('Inbox')
            key = 'FROM'
            print(f"Searching for emails from {sender}... (Attempt {attempt + 1}/{retries})")
            _, data = my_mail.search(None, key, sender)

            if not data[0]:
                print(f"No emails found from {sender}. Waiting for {delay} seconds before retrying...")
                time.sleep(delay)
                continue

            mail_id_list = data[0].split()
            if mail_id_list:
                latest_email_id = mail_id_list[-1]
                print(f"Fetching latest email with ID: {latest_email_id}")
                _, data = my_mail.fetch(latest_email_id, '(RFC822)')
                return data
            else:
                raise Exception("No emails found.")
        except Exception as e:
            if attempt == retries - 1:
                raise Exception(f"An error occurred after {retries} retries: {e}")
            else:
                print(f"Attempt {attempt + 1} failed. Retrying...")

    raise Exception(f"Failed to fetch an email from {sender} after {retries} retries.")

def extract_email_content(user, password, sender):
    my_mail = connect_to_gmail(user, password)

    email_data = fetch_latest_email(my_mail, sender)

    for response_part in email_data:
        if type(response_part) is tuple:
            my_msg = email.message_from_bytes(response_part[1])
            subject = my_msg['subject']
            from_mailer = my_msg['from']
            body = None
            for part in my_msg.walk():
                if part.get_content_type() == 'text/plain':
                    body = part.get_payload()
            # Return the subject, sender, and body content
            return subject, from_mailer, body
    raise Exception("Failed to extract email content")

from robot.api.deco import keyword

@keyword
def extract_mail_content_with_specific_lines(text, *line_numbers):
    try:
        lines = text.splitlines()
        selected_lines = [lines[int(i) - 1].strip() for i in line_numbers if 0 <= int(i) - 1 < len(lines)]
        return selected_lines
    except ValueError as e:
        raise ValueError(f"Error processing line numbers: {e}")
    except IndexError as e:
        raise IndexError(f"Error accessing line numbers: {e}")


@keyword
def delete_emails_from_sender(user, password, sender):
    imap_url = 'imap.gmail.com'

    try:
        # Connect to Gmail
        mail = imaplib.IMAP4_SSL(imap_url)
        mail.login(user, password)
        mail.select('Inbox')

        # Search for emails from the specified sender
        status, data = mail.search(None, 'FROM', f'"{sender}"')
        mail_ids = data[0].split()

        if not mail_ids:
            print("No emails found from the specified sender.")
        else:
            for mail_id in mail_ids:
                mail.store(mail_id, '+FLAGS', '\\Deleted')
            mail.expunge()
            print(f"Deleted {len(mail_ids)} email(s) from {sender}.")

    except imaplib.IMAP4.error as e:
        print(f"IMAP error: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        try:
            mail.logout()
        except:
            pass