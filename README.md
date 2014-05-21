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

*Note: This form does not need an actual form tag to run and should not conflict with any addition forms on the page. Additional work is needed if you wish to use two Pliable Forms on the same page as the field IDs will conflict.*


History
-------
The project concept won the CodeGarden US 2008 package contest. Then I gave the Xbox to my little brother for Christmas and the project sat on the self for 2 years. In the mean time, Umbraco Contour was created. If you are looking for something like this project and have a little bit of money, buy Contour. If you don't have money, try this out. If it works, send me an address or screen shot of your form (my info is in the documentation).


Release Notes
-------------
1.3.0 - Added token ability to the email subject and styled the html email

1.2.1 - Forgot to add the CheckboxList Document Type to 1.2.

1.2.0 - Fixed checkbox issue of not sending the correct value. Added new checkbox list to Pliable fields. Added "placeholder" option to Pliable Text fields to make the default value clear on focus or not.

1.1.0 - Auto Responder message now accepts tokens that pull values from the form. (as suggested by Marcus)

1.0.0 - Use Pliable Form as a stand alone page or pull it into an existing page.

0.9.6 - Fixed the issue with emailing all values of a multiple select field.

0.9.5 - Added Auto Responder; fixed problem with defaultValue fields; removed "$" from javascript to avoid conflicts.

0.9.2 - Fixed: The custom class wasn't being applied on the radio list.

0.9.1 - Fixed a small issue.


Document Types
--------------

### Pliable Form ###
Start with this Document Type to begin creating your form. This includes many settings about the form. From this content node you should be able to create content nodes below to add form fields. Feel free to add you own tabs and properties to this.
* *Form Content* - This is displayed with the form and is replaced when the form is replaced.
* *Submit Button Text* - This string populates the input button or anchor tag that submits the form.
* *Loading Image* - This is the image that is displayed while the Ajax call is waiting for the server's response.
* *Success Content* - This is shown if the form has successfully been emailed.
* *Error Content* - This is shown if there was an error in trying to send the email.
* *To Address* - This overwrites the default To Address set in the Dictionary or Web.config. Mail to multiple recipients by separating each value with a semi-colon.
* *Email Subject* - This overwrites the default Email Subject set in the Dictionary or Web.config.
* *Email Field* - Choose the form field that receives the user's email to enable the Auto Responder.
* *Auto Responder Subject* - Subject of the Auto Responder email sent to the user. Use tokens to personalize the subject.*
* *Auto Responder Text* - The plain text body of the Auto Responder email. If you want to send an HTML formatted email, leave this completely blank. Use tokens to personalize the text.*
* *Auto Responder Html* - The HTML body of the Auto Responder email if the Auto Responder Text is blank. Use tokens to personalize the HTML.*

*Tokens can be used to add field values inside your autoresponder message. Just use curly brackets around the field node names. (e.g. Thank you {First Name} {Last Name}!)*

### Pliable Fields ###
This is just a Master Document Type to hold all of the form field Document Types.

### Pliable Text ###
This can be an input text field or textarea (multi-line text field).

* *Label* - Populates the label for this field.
* *Multiple Line* - Check this for a textarea field.
* *Required*
* *Regex Validation* - This will only validate if required is check and it always runs as case-insensitive.
* *Error Message* - This will be shown if required is checked and the field is left blank or it doesn't pass the validation.
* *Class* - This will add to the existing default "pText" class. Use spaces to include more than one.
* *Default Value* - This will add a value to the input field on its initial load.
* *Placeholder* - This will turn the Default Value into a string that will get cleared away if the field is focused.

### Pliable Select ###
This is a dropdown or multi-select field.
* *Label* - Populates the label for this field.
* *Multiple Selections* - Check this for a multi-select field.
* *Required* - Check this to make anything but the first option required. If Multiple Selections is checked, any selection is required.
* *Error Message* - This will be shown if required is checked and the default option is still selected or nothing at all is selected.
* *Class* - This will add to the existing default "pSelect". Use spaces to include more than one.
* *Options and Values* - Populate the select field by putting each option on a separate line. If you want a value that is different than the option, use the greater than sign (>) to separate the option from the value on the same line (E.g. option>value).

### Pliable Checkbox ###
* *Label* - Populates the label for this field.
* *Required* - Check this to require that the field is checked.
* *Error Message* - This will be shown if required is checked and field is not checked.
* *Class* - This will add to the existing default "pCheckbox" class. Use spaces to include more than one.
* *Checked* - Check this to default this field as checked.

### Pliable Radio List ###
* *Label* - Populates near the Radio List (not an actual label).
* *Required* - Check this to require one of the radio buttons to be checked.
* *Error Message* - This will be shown if required is checked and no radio buttons are checked.
* *Class* - This is applied to a span that surrounds each label and radio button option and applied to the radio button adding to the existing default "pRadio" class. Use spaces to include more than one.
* *Labels and Values* - Populate the labels and radio button options by putting a string for each on a separate line. If you want a radio button value that is different than the label, use the greater than sign (&gt;) to separate the label from the value on the same line (E.g. label&gt;value).

### Pliable Checkbox List ###
* *Label* - Populates near the Checkbox List (not an actual label).
* *Class* - This is applied to a span that surrounds each label and checkbox and applied to the checkbox adding to the existing default "pCheckboxList" class. Use spaces to include more than one.
* *Labels and Values* - Populate the labels and checkbox values by putting a string for each on a separate line. If you want a checkbox value that is different than the label, use the greater than sign (>) to separate the label from the value on the same line (E.g. label>value).


Dictionary Items/Settings
-------------------------
All Dictionary Items can be replaced by keys of the same name placed in the appSettings of the Web.config
* *PliableForm.defaultEmailSubject* - (string)
* *PliableForm.defaultToAddress* - (string) - Mail to multiple recipients by separating each value with a semi-colon.
* *PliableForm.enableSsl* - (bool) - "true" or "false"
* *PliableForm.fromAddress* - (string)


Macros/XSLTs
------------
Add a Pliable Form Macro to your template to run a Pliable Form XSLT that formats the form. You can use these macros inside the editor to call the form from another page. The XSLT is the key to formatting your form to your website design. As a rule, don't change the tag IDs as the field ID, name and value are used by the javascript. The class 'pSubmit' is intended to be used on an input button or an anchor tag. Feel free to change what you want here as this is the "pliableness" of the package.

### Pliable Form ###
Basic xslt that separates each field in paragraph tags.
* *Form Node Id* - Use this when the Pliable Form node is in a different location. Leave this blank if the current page is the Pliable Form.
* *Include jQuery* - Check this parameter if you don't already have jQuery on the page.

### Pliable Form table ###
Basic xslt that formats the fields within a table.
* *Form Node Id* - Use this when the Pliable Form node is in a different location. Leave this blank if the current page is the Pliable Form.
* *Include jQuery* - Check this parameter if you don't already have jQuery on the page.


PliableForm.js
--------------
This contains the code responsible for submitting the form and sending the information by AJAX to the PliableSender.asmx/PliableForm.dll to format and send the email. This also handles any validation that is set on the field. The same validation is not done in the code behind of PliableSender.asmx; by default, .NET should handle malicious requests sent through AJAX form. Feel free to edit the javascript as you feel comfortable.

PliableForm.css
---------------
This optional file is only included to help you understand some of the classes that put on the fields by the xslt and javascript.
* *.pText* - Default class on the input type text and textarea fields.
* *.pSelect* - Default class on the select fields.
* *.pCheckbox* - Default class on the checkbox fields.
* *.pRadio* - Default class on the radio button fields.
* *.pCheckboxList* - Default class on the surrounding span of the label and checkbox fields.
* *.pHighlightText* - Appended class if text field doesn't validate.
* *.pHighlightSelect* - Appended class if the select field doesn't validate.
* *.pHighlightRadioList* - Appended class to a parent element of the radio buttons if the radio list doesn't validate.
* *.pErrorMessage* - Default class on the span containing the validation error message.
* *.defaultValue* - Appended class if the input type text field or textarea contains the default string.
* *.userValue* - Appended class if the default value of an input type text field or textarea is erased.