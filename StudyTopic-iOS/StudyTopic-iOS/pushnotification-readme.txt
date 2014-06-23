push notification APNs //edometita Jun-20-2014 14:10

step#1:
a. create an application on xcode (single view application)
b. take note of the bundle identifier of the application created

step#2:
a. go to developer portal https://developer.apple.com
b. login a paid developer account
c. go to certificates then select identifiers
	c.1. create a new App ID from the App IDs
	c.2. enter the bundle identifier from the application we just created on xcode
	c.3. make sure that push notification is check on the App Services lists

step#3:
a. go to keychain access from your mac 
b. we will need to request a certificate authority (keychain access menu -> certificate assistant -> request a certificate from a certificate authority)
c. save the certificate to disk (its extension name is .certSigningRequest)

step#4:
a. back on the browser and access the App ID we have just created
b. click edit and from the push notification setting we'll uploading the .certSigningRequest we have generated from keychain access
c. after uploading click generate, then we'll download the certificate that apple have just signed (its extension name is .cer)

step#5:
a. after acquiring the certificate (.cer) from apple, double click to install it
b. it should show the certificate on the keychain access (my certificates category)
c. from there we should see two kinds of keychain (these are certificate and private key)
d. we need to export those two files to our mac by right clicking them and select export  (we do not need to put password to them)
e. we should have now two .p12 files
f. we then need to concatenate these two files to create a .pem file

step#6:
a. open up terminal > go to the location of the .p12 files (e.g. cd ~/Desktop)
b. then enter the following commands ( we are converting the .p12 to .pem file because .pem files are ssl files that regular servers most likely accepts and work with)


	b.1. openssl pkcs12 -clcerts -nokeys -out cert.pem -in cert.p12
	b.2. openssl pkcs12 -nocerts -out key.pem -in key.p12
		b.2.1. enter a PEM pass phrase, we will use this later when sending an actual text/message using the push notification service
	b.3. cat cert.pem key.pem > ck.pem


c. we should now have a ck.pem file that we need later for pushing notification to apple server then to be sent to our device

step#7:
a. we need to create a provisioning profile
b. back on the browser on our developers account, go to certificates -> provisioning
c. add a provisioning specifically for the App ID we've created (push notification)
d. after adding provision, we then download that provision file (.mobileprovision) and drag it to xcode 

step#8:
a. open our xcode app then go to window -> organizer then select provisioning profiles
b. once confirm that the provisioning file was added, we'll go to build settings of our app (push notification)
c. from the build settings we need to select the provisioning profile we've just added from the code signing section
d. we then need to add few lines of code into our appdelegate.m, we will add it inside didFinishedLaunchingWithOptions
	d.1. [[UIApplication sharedApplication]  registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)]; this particular line of code is for the app to request permission on the device that will allow a push notification to be come through.
	d.2. we then need to have the devicetoken of a device so that we can able to send a push notification to. we need to add a method, copy and paste below code to appdeletage.m
	- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    		NSString *deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    		NSLog(deviceTokenString);
	}
	d.3. we need to copy the devicetoken of the device and note it as we will be needing it when we push a notification 

step#9:		
a. at this point our push notification app itself is finished, what we need now is a program that we'll push a notification to our app.
b. we are going to use php to send a notification to our app.
c. please copy and paste this php code below then run it on a browser (apache server, internet connection and the ck.pem file are needed)
d. the ck.pem file that we've concatenated earlier should reside in the same folder where this php code is.
e. modify the php code and enter the devicetoken we noted just earlier
f. modify the PEM passphrase -> this passphrase is the one we setup on step#6

<?php
if(@$_POST['message']){
	
	$deviceToken = array();
	$deviceToken[] = “DEVICE TOKEN HERE”;
    
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
    stream_context_set_option($streamContext, 'ssl', 'passphrase', “PEM-PASSPHRASE HERE”);
    
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

e. once the php file is accessible via browser you can able to send message and the message should show on the particular device we’ve registered.

*important : 
a. must have an internet connection
b. port 2195 should be open
c. to be able to receive the push notification message on the device the app (push notification) should be close on your device.


