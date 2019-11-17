<?php

/**
 * @copyright Copyright (C) 2015-2019 AIZAWA Hina
 * @license https://github.com/fetus-hina/stat.ink/blob/master/LICENSE MIT
 * @author AIZAWA Hina <hina@fetus.jp>
 */

declare(strict_types=1);

namespace app\controllers;

use Yii;
use app\actions\api\internal\ActivityAction;
use app\actions\api\internal\CounterAction;
use app\actions\api\internal\CurrentData2Action;
use app\actions\api\internal\CurrentDataAction;
use app\actions\api\internal\GuessTimezoneAction;
use app\actions\api\internal\PatchBattleAction;
use app\actions\api\internal\RecentBattlesAction;
use app\actions\api\internal\SalmonStats2Action;
use app\components\web\Controller;
use yii\filters\VerbFilter;

class ApiInternalController extends Controller
{
    public $enableCsrfValidation = false;

    public function behaviors()
    {
        return [
            'verbs' => [
                'class' => VerbFilter::class,
                'actions' => [
                    'patch-battle' => [ 'patch' ],
                    '*' => [ 'get' ],
                ],
            ],
        ];
    }

    public function actions()
    {
        return [
            'activity' => [ 'class' => ActivityAction::class ],
            'counter' => [ 'class' => CounterAction::class ],
            'current-data' => [ 'class' => CurrentDataAction::class ],
            'current-data2' => [ 'class' => CurrentData2Action::class ],
            'guess-timezone' => [ 'class' => GuessTimezoneAction::class ],
            'patch-battle' => [ 'class' => PatchBattleAction::class ],
            'recent-battles' => [ 'class' => RecentBattlesAction::class ],
            'salmon-stats2' => [ 'class' => SalmonStats2Action::class ],
        ];
    }
}
