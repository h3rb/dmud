<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: insert player data to the db

// Variable names shortened because of limits to some browsers
// Someone suggested replacing this with a POST method through Java url object
$name         = $_GET['n'];
$password     = $_GET['p'];
$wizard       = $_GET['wiz'];
$gender       = $_GET['g'];
$discipline   = $_GET['d'];
$strength     = $_GET['s'];
$intelligence = $_GET['i'];
$wisdom       = $_GET['w'];
$dexterity    = $_GET['de'];
$constitution = $_GET['co'];
$charisma     = $_GET['ch'];
$experience   = $_GET['e'];
$level        = $_GET['l'];
$gold         = $_GET['g'];
$hp           = $_GET['hp'];
$mana         = $_GET['m'];
$damroll      = $_GET['dr'];
$hitroll      = $_GET['hr'];
$ac           = $_GET['ac'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf( 
 "INSERT INTO `players` ( `name` , `password` , `wizard`, `gender` , `discipline` , `strength` , `intelligence` , `wisdom` , `dexterity` , `constitution` , `charisma` , `experience` , `level` , `gold` , `hp` , `mana` , `damroll` , `hitroll` , `ac` )" .
  " VALUES ('" . $name .
 "', '" . $password . "', '" . $wizard .
 "', '" . $gender . "', '" . $discipline .
 "', '" . $strength . "', '" . $intelligence .
 "', '" . $wisdom . "', '" . $dexterity .
 "', '" . $constitution . "', '" . $charisma .
 "', '" . $experience . "', '" . $level .
 "', '" . $gold . "', '" . $hp .
 "', '" . $mana . "', '" . $damroll .
 "', '" . $hitroll . "', '" . $ac .
 "');" );
$result = mysql_query($query);
echo $result;
?>