<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: return player data

// Parse URL
$player_name = $_GET['name'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf( 
 "SELECT * FROM `players` WHERE `players`.`name`='" . $player_name . "' LIMIT 1" );
$result = mysql_query($query);

// Check result
// This shows the actual query sent to MySQL, and the error.
// Useful for debugging.

if ($result) { // Use result to display record
   $found=0;
   while ($row = mysql_fetch_assoc($result)) {
      $found=1;
      echo $row['name']         . "|" . $row['password'] . "|" .
           $row['wizard']       . "|" .
           $row['gender']       . "|" . $row['discipline'] . "|" .
           $row['strength']     . "|" . $row['intelligence'] . "|" .
           $row['wisdom']       . "|" . $row['dexterity'] . "|" .
           $row['constitution'] . "|" . $row['charisma'] . "|" .
           $row['experience']   . "|" . $row['level'] . "|" .
           $row['gold']         . "|" . $row['hp'] . "|" .
           $row['mana']         . "|" . $row['damroll'] . "|" . 
           $row['hitroll']      . "|" . $row['ac'] . "|" .
           $row['location']     . "|";
     }
   if ( $found == 0 ) echo "NEW";
} else echo "DBERROR";
?>    