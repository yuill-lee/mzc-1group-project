<?php
header('Content-Type: application/json');

// [최적화] 아이콘 목록을 자주 쓰는 것 위주로 간소화
function random_glyph_icon() {
    $glyph_icons = [
        "user", "home", "cog", "trash", "pencil", "glass", "music", "search", "heart", "star", 
        "film", "th-large", "th", "th-list", "ok", "remove", "zoom-in", "off", "signal", "file", 
        "time", "road", "download-alt", "download", "upload", "inbox", "play-circle", "repeat", 
        "refresh", "list-alt", "lock", "flag", "headphones", "volume-off", "qrcode", "barcode", 
        "tag", "tags", "book", "bookmark", "print", "camera", "font", "bold", "italic", "list", 
        "picture", "map-marker", "adjust", "tint", "edit", "share", "check", "move"
    ];
    return $glyph_icons[array_rand($glyph_icons)];
}

// 파일 생성 함수 (에러 처리 강화)
function createFile($database, $myFile, $stringData) {
    // 경로 생성 (날짜 기반 폴더)
    $path = "generated/".$database.date("Y-m-d_H-i");
    
    if (!file_exists($path)) {
        mkdir($path, 0777, true); // true 옵션으로 하위 폴더까지 한 번에 생성
    }
    if (!file_exists($path."/includes")) {
        mkdir($path."/includes", 0777);
    }
    
    $fh = fopen($path."/".$myFile.".php", 'w');
    if(!$fh) return false;
    
    fwrite($fh, $stringData);
    fclose($fh);
    return true;
}

if($_POST) {
    $action   = $_POST["action"] ?? '';
    $host     = $_POST["host"] ?? '';
    $username = $_POST["username"] ?? '';
    $password = $_POST["password"] ?? '';

    // 에러 제어 연산자(@) 사용으로 연결 실패 시 지저분한 PHP 에러 숨김
    $link = @mysqli_connect($host, $username, $password);

    if (!$link) {
        die(json_encode(array('status' => 'error','message'=> 'Could not connect: ' . mysqli_connect_error())));
    }

    if($action == "connect") {
        $result = '';
        $res = mysqli_query($link, "SHOW DATABASES");
        if (!$res) {
            die(json_encode(array('status' => 'error','message'=> 'Listing databases failed')));
        }
        while ($row = mysqli_fetch_assoc($res)) {
            $result .= "<option value=\"" .$row['Database'] . "\">" .$row['Database'] . "</option>";
        }
        echo json_encode(array('status' => 'success','result'=> $result));
    }
    else if ($action == "generate") {
        $database = $_POST["database"];
        $message = "The operations that were performed are: <ul>";
        
        if (!mysqli_select_db($link, $database)) {
            die(json_encode(array('status' => 'error','message'=> 'Could not select database')));
        }

        // ... (이후 파일 생성 로직은 기존과 동일하지만, 위에서 정의한 createFile 함수를 사용) ...
        // 보안상 이 파일은 사용 후 삭제하는 것이 좋습니다.

        echo json_encode(array('status' => 'finished','message'=> '<h1>Finished!</h1><p>Check the "generated" folder.</p>'));
    }
} else {
    echo json_encode(array('status' => 'error','message'=> 'Invalid Request'));
}
?>