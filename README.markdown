# Mass Mailer

This is a very simple mass mailer that takes data from a csv file and uses your gmail smtp account to send emails.
Any column from the CSV file can me used in the mail.txt template using the {column_name} format to inject values.
the csv has to contain a column named 'email' that will be used as the destination.