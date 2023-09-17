# when I do sysop maintenance, I found out that the DB usage to big, almost 4 GB, hence I tried to write this script to trim
# amavis DB
# delete log from a year ago

DELETE FROM msgrcpt WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 365 DAY)));
DELETE FROM quarantine WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 365 DAY)));
DELETE FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 365 DAY));

# delete log from 6 months ago, when quarantine_type not Q 
DELETE FROM msgrcpt WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (quar_type <> 'Q' OR quar_type IS NULL)));
DELETE FROM quarantine WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (quar_type <> 'Q' OR quar_type IS NULL)));
DELETE FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (quar_type <> 'Q' OR quar_type IS NULL));

DELETE FROM msgrcpt WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (subject = 'Undelivered Mail Returned to Sender')));
DELETE FROM quarantine WHERE mail_id IN (SELECT mail_id FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (subject = 'Undelivered Mail Returned to Sender')));
DELETE FROM msgs WHERE (time_num < UNIX_TIMESTAMP(NOW() - INTERVAL 180 DAY) AND (subject = 'Undelivered Mail Returned to Sender'));

#DELETE FROM msgrcpt AS q LEFT JOIN msgs AS m ON q.mail_id = m.mail_id WHERE m.mail_id IS NULL;
#DELETE FROM quarantine AS q LEFT JOIN msgs AS m ON q.mail_id = m.mail_id WHERE m.mail_id IS NULL;

# optimize tables
optimize table msgrcpt;
optimize table quarantine;
optimize table msgs;
