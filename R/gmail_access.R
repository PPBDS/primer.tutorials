#
#
# gmail_access <- function(filter){
#   gmailr::gm_auth_configure(key = "",
#                             secret = "")
#
#   gmailr::gm_auth()
#
#   messages <- gmailr::gm_messages(filter)
#
#   for (message_id in messages){
#     msg <- gmailr::gm_message(message_id)
#
#     fn <-
#
#     attach_id = gmailr::gm_attachments(msg)$id[[1]]
#
#     attach_obj <- gmailr::gm_attachment(attach_id, message_id)
#
#     gmailr::gm_save_attachment(attach_obj, fn)
#   }
# }


# Access Gmail with gmailr::gm_auth_configure(key = "", secret = "") and
# gm_auth()
#
# where should we save the key and secret? Maybe environment variables?



# Use gmailr::gm_messages() to search for email based on gmail searchbar filters
#
# "has:attachment" searches for all emails received with an attachment
#
# "before:2004/04/16" searches for all emails before a certain date
#
# "after:2004/04/16" searches for all emails after a certain date
#
# "older_than:2d" or "newer_than:2m" (d is day, m is month, y is year) search
# for all emails older/newer than a time period.
#
# "filename:homework.txt" or "filename:pdf" searches for all emails with certain
# name or file type
#
# More information about gmail operator details:
#
# https://support.google.com/mail/answer/7190?hl=en

# Get message with gmailr::gm_message(message_id)

# Get attachment id with gmailr::gm_attachments(message)$id[[1]]

# Get attachment object with gmailr::gm_attachment(id, message_id)

# Save attachment with gmailr::gm_save_attachment(attachment, filename)

# Full pipeline:
#
# gmailr::gm_auth_configure(key = "KEY", secret = "SECRET_KEY")
#
# gmailr::gm_auth()
#
# for each message_id in gmailr::gm_messages("some filter options"):
#
#   msg = gmailr::gm_message(message_id)
#
#   attachment_id = gmailr::gm_attachments(msg)$id[[1]]
#
#   attachment_obj = gmailr::gm_attachment(attachment_id, message_id)
#
#   gmailr::gm_save_attachment(attachment_obj, filename)
#
#
# gmailr::gm_deauth()



