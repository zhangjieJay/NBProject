<?php
    /*方法汇总
     * <a>先去开发者中心生成推送证书,本地打开后导出p12文件,默认为push.p12,导出时需要设置密码,
     * <b>终端输入(记得cd到push.p12文件的目录,apns-dev.pem是我们要获取到的文件) openssl pkcs12 -in push.p12 -out apns-dev.pem -nodes   这儿需要输入刚刚的密码
     * <c>获取到一个apns-dev.pem的文件后,文件名称将用于方法stream_context_set_option($ctx, 'ssl', 'local_cert', 'apns-dev.pem')最后一个参数
     * <d>终端运行 php -f Jay_APNS.php
     */

    //手机注册应用返回唯一的deviceToken
    $deviceToken = '12dca1f5edea6809a6e15b903522c432b867289a00d0be8480920c177a20a964';//需要发送推送的设备ID
    //ck.pem通关密码 p12文件密码
    $pass = '8517690';//推送证书密码
    //消息内容
    $message = '你收到一条新消息';//消息内容
    //badge通知条数,即角标
    $badge = 1;//App icon显示的通知条数
    //sound 通知发送到手机的提示音名称
    $sound = 'default';//声音名称
    //建设的通知有效载荷（即通知包含的一些信息）
    $body = array();
    $body['id'] = "4f94d38e7d9704f15c000055";
    $body['aps'] = array('alert' => $message);
    $body['aps']['param1'] = 'param1';
    $body['aps']['param2'] = 'param2';

    if ($badge)
    $body['aps']['badge'] = $badge;
    if ($sound)
    $body['aps']['sound'] = $sound;
    //把数组数据转换为json数据
    $payload = json_encode($body);
    echo strlen($payload),"\r\n";
    //下边的写法就是死写法了，一般不需要修改，
    //唯一要修改的就是：ssl://gateway.sandbox.push.apple.com:2195这个是沙盒测试地址，ssl://gateway.push.apple.com:2195正式发布地址
    //socket通讯
    $ctx = stream_context_create();
    stream_context_set_option($ctx, 'ssl', 'local_cert', 'apns-dev.pem');//注意需要配置的推送证书最好放在当前php文件目录下
    stream_context_set_option($ctx, 'ssl', 'passphrase', $pass);
    $fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195',$err,$errstr, 60, STREAM_CLIENT_CONNECT, $ctx);
    if (!$fp) {
        print "Failed to connect $err $errstr\n";
        return;
    }
    else {
        print "Connection OK\n";
    }

    // send message
    $msg = chr(0) . pack("n",32) . pack('H*', str_replace(' ', '', $deviceToken)) . pack("n",strlen($payload)) . $payload;
    print "Sending message :" . $payload . "\n";
    fwrite($fp, $msg);
    fclose($fp);
    ?>
