<?php
// [설정] 에러 표시
ini_set('display_errors', 1);
error_reporting(E_ALL);

include __DIR__ . '/../includes/header.php';

// 1. 기본 정보 수집
$podName = gethostname();
$serverIP = isset($_SERVER['SERVER_ADDR']) ? $_SERVER['SERVER_ADDR'] : '127.0.0.1';

// 2. 부하 발생 로직 (버튼 눌렀을 때 실행)
$isStress = false;
$msg = "";

if (isset($_POST['start_stress'])) {
    $isStress = true;
    $duration = 5; // 5초간 부하 발생
    $endTime = time() + $duration;

    // CPU 부하 루프 (루트 계산 반복)
    while (time() < $endTime) {
        for ($i = 0; $i < 10000; $i++) {
            $x = sqrt(rand(0, 1000000));
        }
    }
    $msg = "🔥 CPU 부하 발생 완료! (5초간 실행됨)";
}
?>

<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <h2 class="page-header">
                <i class="glyphicon glyphicon-dashboard"></i> 통합 대시보드 (Load & Monitor)
            </h2>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-hdd"></i> 현재 접속된 컨테이너(Pod)</h3>
                </div>
                <div class="panel-body text-center">
                    <h4>POD NAME</h4>
                    <h2 class="text-primary" style="word-break: break-all;"><?php echo $podName; ?></h2>
                    <hr>
                    <h4>CONTAINER IP</h4>
                    <h3 class="text-success"><?php echo $serverIP; ?></h3>
                </div>
            </div>
        </div>

        <div class="col-md-6">
            <div class="panel panel-danger">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-fire"></i> 부하 테스트 (Stress Test)</h3>
                </div>
                <div class="panel-body text-center">
                    <p class="lead">버튼을 누르면 CPU 사용량을 <strong>100%</strong>로 올립니다.</p>
                    
                    <div class="progress">
                        <div class="progress-bar progress-bar-<?php echo $isStress ? 'danger' : 'success'; ?> progress-bar-striped active" 
                             role="progressbar" 
                             style="width: <?php echo $isStress ? '100%' : '10%'; ?>">
                            <span>CPU Load: <?php echo $isStress ? '100% (Overload)' : 'Idle'; ?></span>
                        </div>
                    </div>

                    <div class="alert alert-<?php echo $isStress ? 'danger' : 'info'; ?>">
                        <strong>Current Status:</strong> 
                        <?php echo $isStress ? "🚨 사용자 폭주! 오토스케일링이 필요합니다!" : "✅ 시스템 정상 (대기 중)"; ?>
                    </div>

                    <form method="post">
                        <button type="submit" name="start_stress" class="btn btn-danger btn-lg btn-block">
                            <i class="glyphicon glyphicon-flash"></i> 부하 발생시키기 (5초)
                        </button>
                    </form>
                    
                    <?php if($msg): ?>
                        <br><div class="alert alert-success"><?php echo $msg; ?></div>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="alert alert-warning">
                <h4><i class="glyphicon glyphicon-info-sign"></i> 테스트 방법</h4>
                <ol>
                    <li>위의 <strong>[부하 발생시키기]</strong> 버튼을 여러 번(또는 여러 탭에서) 연속으로 누르세요.</li>
                    <li>CPU 부하가 높아지면 쿠버네티스(HPA)가 자동으로 컨테이너를 늘립니다.</li>
                    <li>잠시 후 <strong>[F5 새로고침]</strong>을 했을 때, 왼쪽의 <strong>POD NAME</strong>이 계속 바뀌는지 확인하세요.</li>
                    <li>이름이 바뀐다면 새로운 컨테이너가 생성되어 투입된 것입니다! (Scale-out 성공)</li>
                </ol>
            </div>
        </div>
    </div>
</div>

<?php include __DIR__ . '/../includes/footer.php'; ?>