<?php
include('page.html');
include 'classes/DbFunctions.php';
$visitor_ip = $_SERVER['REMOTE_ADDR'];
$execute=new dbFunction();
$column="ip,time";
$values="'$visitor_ip',CURRENT_TIME";
$insert_visitor=$execute->insert("portofolio_visitors",$column,$values);


?>