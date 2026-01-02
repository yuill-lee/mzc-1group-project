<?php
// [디버깅] 에러가 있으면 화면에 출력하도록 설정 (문제 해결 후 주석 처리 가능)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// 경로 안전성 확보: 현재 파일 위치(__DIR__) 기준으로 상위 폴더의 includes/header.php를 찾음
// 이렇게 하면 경로 문제로 인한 에러를 방지할 수 있습니다.
include __DIR__ . '/../includes/header.php';

// 쿠버네티스 컨테이너(Pod) 정보 추출
$podName = gethostname();
// SERVER_ADDR이 없는 경우(로컬 등)를 대비해 안전하게 처리
$serverIP = isset($_SERVER['SERVER_ADDR']) ? $_SERVER['SERVER_ADDR'] : '127.0.0.1';
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <h2 class="page-header">
                <i class="glyphicon glyphicon-stats"></i> Infrastructure Monitoring
            </h2>
            <ol class="breadcrumb">
                <li><a href="/home.php">Home</a></li>
                <li class="active">Resource Monitor</li>
            </ol>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8 col-md-offset-2">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <i class="glyphicon glyphicon-hdd"></i> Real-time Container Status
                    </h3>
                </div>
                <div class="panel-body text-center">
                    <p class="lead">현재 요청을 처리 중인 컨테이너 정보입니다.</p>
                    <hr>

                    <div class="row">
                        <div class="col-sm-6">
                            <div class="well">
                                <strong><i class="glyphicon glyphicon-tag"></i> POD NAME</strong><br>
                                <span class="text-primary" style="font-size: 1.5em; word-break: break-all;">
                                    <?php echo $podName; ?>
                                </span>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="well">
                                <strong><i class="glyphicon glyphicon-map-marker"></i> CONTAINER IP</strong><br>
                                <span class="text-success" style="font-size: 1.5em;">
                                    <?php echo $serverIP; ?>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-warning">
                        <i class="glyphicon glyphicon-info-sign"></i>
                        부하가 발생하여 <strong>HPA(Autoscaling)</strong>가 작동하면, 새로고침 시 POD NAME이 변경될 수 있습니다.
                    </div>

                    <button onclick="location.reload();" class="btn btn-info btn-lg">
                        <i class="glyphicon glyphicon-refresh"></i> Refresh Status
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<?php
// 푸터도 안전한 경로로 include
include __DIR__ . '/../includes/footer.php';
?>