<?php

include 'classes/DbFunctions.php';
$execute=new dbFunction();
$response=$execute->selectAll('gamerx');
echo json_encode($response);



      ?>
