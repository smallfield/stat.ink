<?php

/**
 * @copyright Copyright (C) 2015-2019 AIZAWA Hina
 * @license https://github.com/fetus-hina/stat.ink/blob/master/LICENSE MIT
 * @author AIZAWA Hina <hina@fetus.jp>
 */

declare(strict_types=1);

namespace app\components\widgets;

use Yii;
use app\assets\FallbackableImageAsset;
use yii\base\Widget;
use yii\helpers\Html;
use yii\helpers\Json;
use yii\helpers\Url;

class FallbackableImage extends Widget
{
    public $srcs = [];
    public $options = [];

    public function run(): string
    {
        $srcs = array_map(
            function (string $url): string {
                return Url::to($url, true);
            },
            array_filter(
                (array)$this->srcs,
                function (?string $url): bool {
                    return $url !== null;
                }
            )
        );

        if (empty($this->srcs)) {
            return '';
        }

        if (count($srcs) === 1) {
            return Html::img(
                array_values($srcs)[0],
                array_merge(
                    $this->options,
                    ['id' => $this->id]
                )
            );
        }

        FallbackableImageAsset::register($this->view);
        $this->view->registerJs(vsprintf('jQuery(%s).fallbackableImage(%s);', [
            Json::encode('#' . $this->id),
            Json::encode(array_map([Yii::class, 'getAlias'], $srcs)),
        ]));

        return Html::img(
            'data:image/gif;base64,R0lGODlhAQABAGAAACH5BAEKAP8ALAAAAAABAAEAAAgEAP8FBAA7',
            array_merge(
                $this->options,
                ['id' => $this->id]
            )
        );
    }
}
