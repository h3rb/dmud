<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: saves player data to the db

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
$mana         = $_GET['m'];
$ac           = $_GET['ac'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf( 
 "UPDATE 'Players' SET (name='" . $name .
 "', password='" . $password . "', wizard='" . $wizard .
 "', gender='" . $gender . "', discipline='" . $discipline .
 "', strength='" . $strength . "', intelligence='" . $intelligence .
 "', wisdom='" . $wisdom . "', dexterity='" . $dexterity .
 "', constitution='" . $constitution . "', charisma='" . $charisma .
 "', experience='" . $experience . "', level='" . $level .
 "', gold='" . $gold . "', hp='" . $hp . "', mana='" . $mana .
 "', damroll='" . $damroll . "', hitroll='" . $hitroll .
 "', mana='" . $mana . "', ac='" . $ac . "') WHERE name='" . $name . 
 "' LIMIT 1" );
$result = mysql_query($query);

?>    