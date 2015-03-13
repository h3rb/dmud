<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: digs a new scene

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$sql = 'INSERT INTO `scenes` ( `title` , `description` , `north` , `south` , `east` , `west` , `up`, `down`, `type` ) '
     . ' VALUES ( \'Somewhere\', \'You are somewhere.\', \'0\', \'0\', \'0\', \'0\', \'0\', \'0\', \'enclosed\' )';
$result = mysql_query($sql);

$sql = "SELECT LAST_INSERT_ID()";
$result = mysql_query($sql);
if ( $result ) while ( $row = mysql_fetch_assoc($result) ) echo $row['last_insert_id()'];
else echo "DBERROR";
?>