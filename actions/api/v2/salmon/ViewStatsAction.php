<?php

/**
 * @copyright Copyright (C) 2015-2018 AIZAWA Hina
 * @license https://github.com/fetus-hina/stat.ink/blob/master/LICENSE MIT
 * @author AIZAWA Hina <hina@fetus.jp>
 */

declare(strict_types=1);

namespace app\actions\api\v2\salmon;

use Yii;
use app\models\SalmonStats2;
use yii\helpers\Url;
use yii\web\BadRequestHttpException;
use yii\web\NotFoundHttpException;
use yii\web\UnauthorizedHttpException;

class ViewStatsAction extends \yii\web\ViewAction
{
    public function init()
    {
        parent::init();

        Yii::$app->language = 'en-US';
        Yii::$app->timeZone = 'Etc/UTC';
    }

    public function run()
    {
        if (Yii::$app->user->isGuest) {
            throw new UnauthorizedHttpException('Unauthorized');
        }

        $query = SalmonStats2::find()
            ->andWhere(['user_id' => Yii::$app->user->id])
            ->orderBy(['as_of' => SORT_DESC])
            ->limit(1);

        $id = Yii::$app->request->get('id');
        if ($id != '') {
            if (filter_var($id, FILTER_VALIDATE_INT) === false) {
                throw new BadRequestHttpException('Bad Request: id');
            }

            $query->andWhere(['id' => (int)$id]);
        }

        if (!$model = $query->one()) {
            throw new NotFoundHttpException('Not Found');
        }

        $resp = Yii::$app->response;
        $resp->format = 'compact-json';
        return $model->toJsonArray();
    }
}
