Pliable Ajax Contact Form
=========================

Pliable Form allows your content writers to create their own custom forms right in the content section. These AJAX forms will send emails to the recipients specified. You can create text fields, dropdowns, checkboxes, and radio lists. Specify required fields, regex validation, and additional class names on each field.

Features
--------
* Unlimited custom fields and forms
* Custom validation and error messages
* XSLT for easy markup changes
* Personalized auto responder
* AJAX submission
* Easy to style
* Multilingual
* Use the form from an "in editor" macro.

Requirements
------------
* Umbraco 4.5.x - 4.7.x with the new schema (for legacy, use the added legacy xslt in the archive to help convert the latest xslt to a legacy xslt.)
* .NET 4.0 (for 3.5, use the 3.5 build download)

Set Up
------
1. Install PliableForm.umb package.
2. Use the Pliable Form Document Type in your content tree.
3. Assign fields to it by adding new content nodes below the form.
4. Create a template and assign the form to it. This is optional because you can just use the macro to link to the form.
5. Use a Pliable Form macro to add to the template you created.
6. Edit the Pliable Form dictionary items to change mail settings.
7. Add smtp mail server settings to the web.config.

History
-------
The project concept won the CodeGarden US 2008 package contest. Then I gave the Xbox to my little brother for Christmas and the project sat on the self for 2 years. In the mean time, Umbraco Contour was created. If you are looking for something like this project and have a little bit of money, buy Contour. If you don't have money, try this out. If it works, send me an address or screen shot of your form (my info is in the documentation).

Release Notes
-------------
1.3 - Added token ability to the email subject and styled the html email
1.2.1 - Forgot to add the CheckboxList Document Type to 1.2.
1.2 - Fixed checkbox issue of not sending the correct value. Added new checkbox list to Pliable fields. Added "placeholder" option to Pliable Text fields to make the default value clear on focus or not.
1.1 - Auto Responder message now accepts tokens that pull values from the form. (as suggested by Marcus)
1.0 - Use Pliable Form as a stand alone page or pull it into an existing page.
.9.6 - Fixed the issue with emailing all values of a multiple select field.
.9.5 - Added Auto Responder; fixed problem with defaultValue fields; removed "$" from javascript to avoid conflicts.
.9.2 - Fixed: The custom class wasn't being applied on the radio list.
.9.1 - Fixed a small issue.