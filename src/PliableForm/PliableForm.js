jQuery(function() {
  if(document.getElementById('PliableForm')) {
    var pliable = new PliableForm();
  }
  else {
   alert('Please surround all the field items with an element that has an ID of "PliableForm".'); 
  }
});

function PliableForm() {
  var $form = jQuery('#PliableForm');
  
  function submitForm() {
    $form.hide();
    var $loader = jQuery('#PliableForm_loading');
    $loader.show();
    
    var fieldIds = [];
    var names = [];
    var data = [];
    var x = 0;
    var checkboxLists = [];
    $form.find('input, textarea, select').each(function() {
      if(this.type == "radio" && !this.checked) {
        return;
      }
      var $this = jQuery(this);
      if($this.hasClass('placeholder')) {
        data[x] = "";
      }
      else if(this.type == "select-multiple") {
        var $opts = $this.find('option:selected');
        data[x] = "";
        $opts.each(function(i) {
          data[x] += this.value;
          if(i < $opts.length - 1) {
            data[x] += ", ";
          }
        });
      }
      else if(this.type == "select-one") {
        data[x] = this.options[this.selectedIndex].value;
      }
      else if(this.type == "checkbox") {
        if($this.hasClass('pCheckboxList')) {
          var itemID = this.id.substring(this.id.lastIndexOf('_'));
          if(jQuery.inArray(itemID,checkboxLists) > -1) {
            return;
          }
          checkboxLists.push(itemID);
          var itemValue = "";
          $form.find('input[id$='+itemID+']:checked').each(function(i) {
            if(i != 0) {
              itemValue += ", ";
            }
            itemValue += this.value;
          });
          data[x] = itemValue;
        }
        else {
          data[x] = this.checked;
        }
      }
      else {
        data[x] = this.value;
      }
      fieldIds[x] = this.id;
      names[x] = this.name;
      x++;
    });
    
    var request = {};
    request.FieldIds = fieldIds;
    request.Names = names;
    request.Values = data;
    request.Id = jQuery('#PliableForm_id').val();
    
    var DTO = { 'request' : request };

    jQuery.ajax({
      async: true,
      type: "POST",
      contentType: "application/json; charset=utf-8",
      url: "/umbraco/PliableSender.asmx/sendForm",
      data: jQuery.toJSON(DTO),
      dataType: "json",
      success: function(result, textStatus) {
        $loader.hide();
        if(result.d.Result == '3') {
          //alert(result.d.Msg);
          jQuery('#PliableForm_error').show().append('<p class="pErrorMessage">'+result.d.Msg+'</p>');
        }
        else {
          jQuery('#PliableForm_success').show();
        }
      },
      error: function(request, status, err) {
        $loader.hide();
        jQuery('#PliableForm_error').show().append('<p class="pErrorMessage">'+err+'</p>');
      },
      complete: function(XMLHttpRequest, textStatus) {
       $loader.hide();
      }
    });
  }
  
  function checkRequiredText(field) {
    if(!field.disabled) {
      var $this = $(field);
      if($.trim(field.value).length > 0 && !$this.hasClass('placeholder')) {
        if($this.attr('data-validation')) {
          var re = new RegExp($this.attr('data-validation'),'i');
          if(re.test(field.value)) {
            $this.removeClass('pHighlightText');
            jQuery('#'+field.id+'_error').hide();
            return true;
          }
          else {
            $this.addClass('pHighlightText');
            jQuery('#'+field.id+'_error').show();
            return false;
          }
        }
        else {
          $this.removeClass('pHighlightText');
          jQuery('#'+field.id+'_error').hide();
          return true;
        }
      }
      else {
        $this.addClass('pHighlightText');
        jQuery('#'+field.id+'_error').show();
        return false;
      }
    }
    else {
      return true; 
    }
  }
  
  function checkRequiredSelect(field) {
    if(!field.disabled) {
      var $this = $(field);
      var index = 0;
      if($this.attr('multiple')) {
        index = -1;
      }
      if(field.selectedIndex > index) {
        $this.removeClass('pHighlightSelect');
        jQuery('#'+field.id+'_error').hide();
        return true;
      }
      else {
        $this.addClass('pHighlightSelect');
        jQuery('#'+field.id+'_error').show();
        return false;
      }
    }
    else {
      return true;
    }
  }
  
  function checkRequiredCheckbox(field) {
    if(!field.disabled) {
      var $this = $(field);
      if($this.attr('checked')) {
        $this.removeClass('pHighlightCheckbox');
        jQuery('#'+field.id+'_error').hide();
        return true;
      }
      else {
        $this.addClass('pHighlightCheckbox');
        jQuery('#'+field.id+'_error').show();
        return false;
      }
    }
    else {
      return true;
    }
  }
  
  function checkRequiredRadioList(field) {
    var $this = $(field);
    var count = 0;
    $this.find('input[type=radio]').each(function() {
      if($(this).attr('checked')) {
        count++;
      }
    });
    if(count > 0) {
      $this.removeClass('pHighlightRadio');
      jQuery('#'+field.id+'_error').hide();
      return true;
    }
    else {
      $this.addClass('pHighlightRadio');
      jQuery('#'+field.id+'_error').show();
      return false;
    }
  }
  
  function validateForm() {
    var count = 0;
    $form.find('input.pRequiredText, textarea.pRequiredText').each(function() {
      if(!checkRequiredText(this)) {
        count++;
      }
    });
    $form.find('select.pRequiredSelect').each(function() {
      if(!checkRequiredSelect(this)) {
          count++;
      }
    });
    $form.find('input.pRequiredCheckbox').each(function() {
      if(!checkRequiredCheckbox(this)) {
          count++;
      }
    });
    $form.find('.pRequiredRadioList').each(function() {
      if(!checkRequiredRadioList(this)) {
          count++;
      }
    });
    if(count > 0) {
      // Validation Failed
      return false;
    }
    else {
      return true;
    }
  }
  
  $form.find('.pSubmit').click(function(e) {
    e.preventDefault();
    if(validateForm()) {
      submitForm();
    }
  });
  
  $form.find('input.pRequiredText, textarea.pRequiredText').blur(function() {
    checkRequiredText(this);
  });
  $form.find('select.pRequiredSelect').change(function() {
    checkRequiredSelect(this);
  });
  $form.find('input.pRequiredCheckbox').click(function() {
    checkRequiredCheckbox(this);
  });
  $form.find('.pRequiredRadioList').each(function() {
    var list = this;
    jQuery(this).find('input[type=radio]').click(function() {
      checkRequiredRadioList(list);
    });
  });
  $form.find('input.placeholder, textarea.placeholder').placeholder();
  $form.find('input').keypress(function(e) {
    if(e.which == 13) {
      e.preventDefault();
      if(validateForm()) {
        submitForm();
      }
    }
  });
}




(function($) {

$.fn.placeholder = function(defaultValue) {
  return this.each(function() {
    var val = this.defaultValue;
    if(defaultValue) { val = defaultValue; }
    if(this.value != val) {
      $(this).removeClass('placeholder').addClass('userinput');
    }
    $(this).focus(function() {
      if(val == this.value) {
        this.value = "";
      }
      $(this).removeClass('placeholder').addClass('userinput');
    });
    $(this).blur(function() {
      if(this.value.replace(/\s/g,"").length < 1) {
        this.value = val;
        $(this).addClass('placeholder').removeClass('userinput');
      }
    });
  });
};

})(jQuery);


/* add JSON capabilities for all browsers */
(function($){function toIntegersAtLease(n)
{return n<10?'0'+n:n;}
Date.prototype.toJSON=function(date)
{return date.getUTCFullYear()+'-'+
toIntegersAtLease(date.getUTCMonth()+1)+'-'+
toIntegersAtLease(date.getUTCDate());};var escapeable=/["\\\x00-\x1f\x7f-\x9f]/g;var meta={'\b':'\\b','\t':'\\t','\n':'\\n','\f':'\\f','\r':'\\r','"':'\\"','\\':'\\\\'}
$.quoteString=function(string)
{if(escapeable.test(string))
{return'"'+string.replace(escapeable,function(a)
{var c=meta[a];if(typeof c==='string'){return c;}
c=a.charCodeAt();return'\\u00'+Math.floor(c/16).toString(16)+(c%16).toString(16);})+'"'}
return'"'+string+'"';}
$.toJSON=function(o,compact)
{var type=typeof(o);if(type=="undefined")
return"undefined";else if(type=="number"||type=="boolean")
return o+"";else if(o===null)
return"null";if(type=="string")
{return $.quoteString(o);}
if(type=="object"&&typeof o.toJSON=="function")
return o.toJSON(compact);if(type!="function"&&typeof(o.length)=="number")
{var ret=[];for(var i=0;i<o.length;i++){ret.push($.toJSON(o[i],compact));}
if(compact)
return"["+ret.join(",")+"]";else
return"["+ret.join(", ")+"]";}
if(type=="function"){throw new TypeError("Unable to convert object of type 'function' to json.");}
ret=[];for(var k in o){var name;var type=typeof(k);if(type=="number")
name='"'+k+'"';else if(type=="string")
name=$.quoteString(k);else
continue;val=$.toJSON(o[k],compact);if(typeof(val)!="string"){continue;}
if(compact)
ret.push(name+":"+val);else
ret.push(name+": "+val);}
return"{"+ret.join(", ")+"}";}
$.compactJSON=function(o)
{return $.toJSON(o,true);}
$.evalJSON=function(src)
{return eval("("+src+")");}
$.secureEvalJSON=function(src)
{var filtered=src;filtered=filtered.replace(/\\["\\\/bfnrtu]/g,'@');filtered=filtered.replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,']');filtered=filtered.replace(/(?:^|:|,)(?:\s*\[)+/g,'');if(/^[\],:{}\s]*$/.test(filtered))
return eval("("+src+")");else
throw new SyntaxError("Error parsing JSON, source is not valid.");}})(jQuery);

