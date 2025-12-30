<?php
error_reporting(0);
// header to return JSON to the jQuery Ajax request
header('Content-Type: application/json');

// function for removing last colon
function removeLastChar($string) {
    $string = substr($string, 0, -1);
    return $string;
}

// [수정] 파일 생성 함수: __DIR__를 사용하여 상위 폴더의 generated를 정확히 찾음
function createFile($database, $myFile, $stringData) {
    // 현재 폴더(users)의 상위(Service)에 있는 generated 폴더를 지정
    $path = __DIR__ . "/../generated/" . $database . date("Y-m-d_H-i");
    
    if (!file_exists($path)) {
        mkdir($path, 0777, true); // true 옵션으로 하위 폴더까지 한 번에 생성
    }
    
    // includes 폴더 체크 및 생성
    if (!file_exists($path . "/includes")) {
        mkdir($path . "/includes", 0777, true);
    }

    $fh = fopen($path . "/" . $myFile . ".php", 'w') or die(json_encode(array('status' => 'error','message'=> '파일 생성 실패: ' . $path)));
    fwrite($fh, $stringData);
    fclose($fh);
    return $path; // 생성된 실제 경로를 반환하도록 수정
}

// 원본의 긴 아이콘 목록 유지
function random_glyph_icon() {
    $glyph_icons = array("asterisk", "plus", "euro", "eur", "minus", "cloud", "envelope", "pencil", "glass", "music", "search", "heart", "star", "star-empty", "user", "film", "th-large", "th", "th-list", "ok", "remove", "zoom-in", "zoom-out", "off", "signal", "cog", "file", "time", "road", "download-alt", "download", "upload", "inbox", "play-circle", "repeat", "refresh", "list-alt", "lock", "flag", "headphones", "volume-off", "volume-down", "volume-up", "qrcode", "barcode", "tag", "tags", "book", "bookmark", "print", "camera", "font", "bold", "italic", "text-height", "text-width", "align-left", "align-center", "align-right", "align-justify", "list", "indent-left", "indent-right", "facetime-video", "picture", "map-marker", "adjust", "tint", "share", "check", "move", "step-backward", "fast-backward", "backward", "play", "pause", "stop", "forward", "fast-forward", "step-forward", "eject", "chevron-left", "chevron-right", "plus-sign", "minus-sign", "remove-sign", "ok-sign", "question-sign", "info-sign", "screenshot", "remove-circle", "ok-circle", "ban-circle", "arrow-left", "arrow-right", "arrow-up", "arrow-down", "share-alt", "resize-full", "resize-small", "exclamation-sign", "gift", "leaf", "fire", "eye-open", "eye-close", "warning-sign", "plane", "calendar", "random", "comment", "magnet", "chevron-up", "chevron-down", "retweet", "shopping-cart", "folder-close", "folder-open", "resize-vertical", "resize-horizontal", "hdd", "bullhorn", "bell", "certificate", "thumbs-up", "thumbs-down", "hand-right", "hand-left", "hand-up", "hand-down", "circle-arrow-right", "circle-arrow-left", "circle-arrow-up", "circle-arrow-down", "globe", "wrench", "tasks", "filter", "briefcase", "fullscreen", "dashboard", "paperclip", "heart-empty", "link", "phone", "pushpin", "usd", "gbp", "sort", "sort-by-alphabet", "sort-by-alphabet-alt", "sort-by-order", "sort-by-order-alt", "sort-by-attributes", "sort-by-attributes-alt", "unchecked", "expand", "collapse-down", "collapse-up", "log-in", "flash", "new-window", "record", "save", "open", "saved", "import", "export", "send", "floppy-disk", "floppy-saved", "floppy-remove", "floppy-save", "floppy-open", "credit-card", "transfer", "cutlery", "header", "compressed", "earphone", "phone-alt", "tower", "stats", "sd-video", "hd-video", "subtitles", "sound-stereo", "sound-dolby", "sound-5-1", "sound-6-1", "sound-7-1", "copyright-mark", "registration-mark", "cloud-download", "cloud-upload", "tree-conifer", "tree-deciduous", "cd", "save-file", "open-file", "level-up", "copy", "paste", "alert", "equalizer", "king", "queen", "pawn", "bishop", "knight", "baby-formula", "tent", "blackboard", "bed", "apple", "erase", "hourglass", "lamp", "duplicate", "piggy-bank", "scissors", "bitcoin", "btc", "xbt", "yen", "jpy", "ruble", "rub", "scale", "ice-lolly", "ice-lolly-tasted", "education", "option-horizontal", "option-vertical", "menu-hamburger", "modal-window", "oil", "grain", "sunglasses", "text-size", "text-color", "text-background", "object-align-top", "object-align-bottom", "object-align-horizontal", "object-align-left", "object-align-vertical", "object-align-right", "triangle-right", "triangle-left", "triangle-bottom", "triangle-top", "console", "superscript", "subscript", "menu-left", "menu-right", "menu-down", "menu-up");
    $rand = array_rand($glyph_icons, 1);
    return $glyph_icons[$rand];
}


if($_POST) {
    $action     = $_POST["action"];
    $host       = $_POST["host"];
    $username   = $_POST["username"];
    $password   = $_POST["password"];

    $link = mysqli_connect($host, $username, $password);

    if (!$link) {
        die(json_encode(array('status' => 'error','message'=> 'Could not connect: ' . mysqli_error($link))));
    }

    if($action == "connect") {
        $result = '';
        $res = mysqli_query($link, "SHOW DATABASES");
        while ($row = mysqli_fetch_assoc($res)) {
            $result .= "<option value=\"" .$row['Database'] . "\">" .$row['Database'] . "</option>";
        }
        echo json_encode(array('status' => 'success','result'=> $result));
    }

    else if ($action == "generate") {
        $database = $_POST["database"];
        $message = "The operations that were performed are: <ul>";

        mysqli_select_db($link, $database);
        // 테이블 생성 로직 (생략 없이 원본 유지)
        $sql = "CREATE TABLE IF NOT EXISTS `users` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(255) NOT NULL, `email` varchar(255) NOT NULL, `password` varchar(255) NOT NULL, `role` int(11) NOT NULL, PRIMARY KEY (`id`) ) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2";
        mysqli_query($link, $sql);
        mysqli_query($link, "INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`) VALUES (1, 'Admin', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1)");

        $loop = mysqli_query($link, "SHOW tables FROM $database");

        // --- 여기서부터 원본의 모든 변수 설정($connection, $save, $index, $header 등)이 들어갑니다 ---
        // (지면상 모든 HTML 텍스트를 나열하지 않지만, 원본의 내용을 그대로 사용하시면 됩니다.)
        
        // ... 원본의 복잡한 루프 및 문자열 생성 로직 ...
        
        // [중요] 마지막 파일 생성 부분의 경로 수정
        $actualPath = createFile($database, "includes/connect", $connection);
        createFile($database, "save", $save);
        createFile($database, "includes/footer", $footer);
        createFile($database, "home", $index);
        createFile($database, "includes/header", $header);

        // [수정] 라이브러리 복사 경로: __DIR__를 사용하여 상위 library 폴더 참조
        $libraryBase = __DIR__ . "/../library/";
        
        copy($libraryBase."index.php", $actualPath."/index.php");
        copy($libraryBase."login.php", $actualPath."/login.php");
        copy($libraryBase."logout.php", $actualPath."/logout.php");
        copy($libraryBase."data.php", $actualPath."/includes/data.php");
        copy($libraryBase."style.css", $actualPath."/includes/style.css");

        // 결과 URL 계산
        $relativeUrl = "generated/" . basename($actualPath);
        
        echo json_encode(array(
            'status' => 'finished',
            'message'=> '<h1>Finished!</h1><h3>ID: admin / PW: admin</h3><br><a href="/'.$relativeUrl.'" target="_blank">Visit Admin Panel</a><br>'.$message
        ));
    }
}
?>