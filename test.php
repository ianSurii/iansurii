

<!DOCTYPE html>
<html>
  <head>
    <title>www.W3docs.com</title>
    <style>
      input {
        height: 30px;
        padding-left: 10px;
        border-radius: 4px;
        border: 1px solid rgb(186, 178, 178);
        box-shadow: 0px 0px 12px #EFEFEF;
      }
    </style>
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBuUhnC2p8pB65r6S9oHyXQdKY3VvUUqCI&libraries=places"></script>>
  </head>
  <body>
    <input type="text" id="autocomplete"/>

    <script>
      var input = document.getElementById('autocomplete');
      var autocomplete = new google.maps.places.Autocomplete(input,{types: ['(cities)']});
      google.maps.event.addListener(autocomplete, 'place_changed', function(){
         var place = autocomplete.getPlace();
      })
    </script>
  </body>
</html>

