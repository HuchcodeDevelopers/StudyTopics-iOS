<?php

//session_start();
//2e4ad60e 609c8e73 f491d821 1e520a7e 93e65fca b042e8e7 4c1302dc c1a7ac48

if(@$_POST['message']){
	
	$deviceToken = array();
	$deviceToken[] = '7af944ed dcf83208 6b4b58da 6dd086d4 9f948b8e 3680b535 c37f697c 3de8c80a';
    
    $payload = '
    {
	    "aps": {
	        "alert": "'.$_POST['message'].'",
	        "sound": "default"
	    },
	    "message": "'.$_POST['message'].'",
	    "id": 1234
	}
    ';
    $apnsHost = 'gateway.sandbox.push.apple.com';
    $apnsPort = 2195;
    $apnsCert = 'ck.pem';
    $streamContext = stream_context_create();
    stream_context_set_option($streamContext, 'ssl', 'local_cert', $apnsCert);
    stream_context_set_option($streamContext, 'ssl', 'passphrase', "kitiwit");
    
    $apns = stream_socket_client('ssl://' . $apnsHost . ':' . $apnsPort, $error, $errorString, 60, STREAM_CLIENT_CONNECT, $streamContext);
    
    if (!$apns)
    	echo "unable to connect";
    
    
    foreach($deviceToken as $key=>$value){
        $apnsMessage = chr(0) . chr(0) . chr(32) . @pack('H*', str_replace(' ', '', $value)) . chr(0) . chr(strlen($payload)) . $payload;
        fwrite($apns, $apnsMessage);
    }
    fclose($apns);
}
?>
<form action="" method="post">
	<input type="text" placeholder="message" name="message">
	<input type="submit" value="submit">
</form>