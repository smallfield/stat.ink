{{strip}}
  {{set layout="main.tpl"}}
  {{use class="yii\bootstrap\ActiveForm" type="block"}}
  {{use class="yii\helpers\Url"}}
  {{use class="yii\widgets\ListView"}}
  {{$name = '{0}-san'|translate:'app':$user->name}}
  {{$title = "{0}'s SplatLog"|translate:'app':$name}}
  {{set title="{{$app->name}} | {{$title}}"}}

  {{$this->registerLinkTag(['rel' => 'canonical', 'href' => $permLink])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:card', 'content' => 'summary'])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:title', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:description', 'content' => $title])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:url', 'content' => $permLink])|@void}}
  {{$this->registerMetaTag(['name' => 'twitter:site', 'content' => '@stat_ink'])|@void}}
  {{if $user->twitter != ''}}
    {{$this->registerMetaTag(['name' => 'twitter:creator', 'content' => '@'|cat:$user->twitter])|@void}}
  {{/if}}

  <div class="container">
    <h1>
      {{$title|escape}}
    </h1>
    
    {{$battle = $user->latestBattle}}
    {{if $battle && $battle->agent && $battle->agent->isIkaLog}}
      {{if $battle->agent->getIsOldIkalogAsAtTheTime($battle->at)}}
        {{registerCss}}
          .old-ikalog {
            font-weight: bold;
            color: #f00;
          }
        {{/registerCss}}
        <p class="old-ikalog">
          {{'These battles were recorded with an outdated version of IkaLog. Please upgrade to the latest version.'|translate:'app'|escape}}
        </p>
      {{/if}}
    {{/if}}

    {{$_btl = $summary->battle_count}}
    {{if $summary->wp === null}}
      {{$_wp = '-'}}
    {{else}}
      {{$_wp = $summary->wp|string_format:'%.1f%%'}}
    {{/if}}
    {{if $summary->kd_present > 0}}
      {{$_kill = ($summary->total_kill/$summary->kd_present)|string_format:'%.2f'}}
      {{$_death = ($summary->total_death/$summary->kd_present)|string_format:'%.2f'}}
      {{if $summary->total_death == 0}}
        {{if $summary->total_kill == 0}}
          {{$_kr = '-'}}
        {{else}}
          {{$_kr = '∞'}}
        {{/if}}
      {{else}}
        {{$_kr = ($summary->total_kill/$summary->total_death)|string_format:'%.2f'}}
      {{/if}}
    {{else}}
      {{$_kill = '-'}}
      {{$_death = '-'}}
      {{$_kr = '-'}}
    {{/if}}
    {{$_formatted = 'Battles:{0} / Win %:{1} / Avg Killed:{2} / Avg Dead:{3} / Kill Ratio:{4}'|translate:'app':[$_btl,$_wp,$_kill,$_death,$_kr]}}
    {{$_tweet = $title|cat:' [ ':$_formatted:' ]'}}
    {{SnsWidget tweetText=$_tweet}}

    <div class="row">
      <div class="col-xs-12 col-sm-8 col-md-8 col-lg-9">
        <div class="text-center">
          {{ListView::widget([
              'dataProvider' => $battleDataProvider,
              'itemOptions' => [ 'tag' => false ],
              'layout' => '{pager}',
              'pager' => [
                'maxButtonCount' => 5
              ]
            ])}}
        </div>
        <div style="margin-bottom:15px">
          <div class="row">
            <div class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
              <div class="user-label">
                {{'Summary: Based on the current filter'|translate:'app'|escape}}
              </div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'Battles'|translate:'app'|escape}}</div>
              <div class="user-number">{{$summary->battle_count|number_format|escape}}</div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'Win %'|translate:'app'|escape}}</div>
              <div class="user-number">
                {{if $summary->wp === null}}
                  {{'N/A'|translate:'app'|escape}}
                {{else}}
                  {{$summary->wp|string_format:'%.1f%%'|escape}}
                {{/if}}
              </div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'24H Win %'|translate:'app'|escape}}</div>
              <div class="user-number">
                {{if $summary->wp_short === null}}
                  {{'N/A'|translate:'app'|escape}}
                {{else}}
                  {{$summary->wp_short|string_format:'%.1f%%'|escape}}
                {{/if}}
              </div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'Avg Killed'|translate:'app'|escape}}</div>
              <div class="user-number">
                {{if $summary->kd_present > 0}}
                  {{$p = ['number' => $summary->total_kill, 'battle' => $summary->kd_present]}}
                  {{$t = '{number} killed in {battle, plural, =1{1 battle} other{# battles}}'|translate:'app':$p}}
                  <span class="auto-tooltip" title="{{$t|escape}}">
                    {{($summary->total_kill/$summary->kd_present)|string_format:'%.2f'|escape}}
                  </span>
                {{else}}
                  {{'N/A'|translate:'app'|escape}}
                {{/if}}
              </div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'Avg Dead'|translate:'app'|escape}}</div>
              <div class="user-number">
                {{if $summary->kd_present > 0}}
                  {{$p = ['number' => $summary->total_death, 'battle' => $summary->kd_present]}}
                  {{$t = '{number} dead in {battle, plural, =1{1 battle} other{# battles}}'|translate:'app':$p}}
                  <span class="auto-tooltip" title="{{$t|escape}}">
                    {{($summary->total_death/$summary->kd_present)|string_format:'%.2f'|escape}}
                  </span>
                {{else}}
                  {{'N/A'|translate:'app'|escape}}
                {{/if}}
              </div>
            </div>
            <div class="col-xs-4 col-sm-4 col-md-2 col-lg-2">
              <div class="user-label">{{'Kill Ratio'|translate:'app'|escape}}</div>
              <div class="user-number">
                {{if $summary->kd_present > 0}}
                  {{if $summary->total_death == 0}}
                    {{if $summary->total_kill}}
                      {{'N/A'|translate:'app'|escape}}
                    {{else}}
                      ∞
                    {{/if}}
                  {{else}}
                    {{($summary->total_kill/$summary->total_death)|string_format:'%.2f'|escape}}
                  {{/if}}
                {{else}}
                  -
                {{/if}}
              </div>
            </div>
          </div>
        </div>
        <div>
          <a href="#filter-form" class="visible-xs-inline btn btn-info">
            <span class="fa fa-search left"></span>{{'Search'|translate:'app'|escape}}
          </a>&#32;
          {{$params = array_merge($filter->toQueryParams(), ['v' => 'standard', '0' => 'show/user'])}}
          <a href="{{Url::to($params)|escape}}" class="btn btn-default" rel="nofollow">
            <span class="fa fa-list left"></span>{{'Detailed List'|translate:'app'|escape}}
          </a>
        </div>
        <div id="battles">
          <ul class="simple-battle-list">
            {{ListView::widget([
              'dataProvider' => $battleDataProvider,
              'itemView' => 'battle.simple.tablerow.tpl',
              'itemOptions' => [ 'tag' => false ],
              'layout' => '{items}'
            ])}}
          </ul>
          {{registerCss}}
            .simple-battle-list{
              display:block;
              list-style:type:0;
              margin:0;
              padding:0;
            }
          {{/registerCss}}
        </div>
        <div class="text-center">
          {{ListView::widget([
              'dataProvider' => $battleDataProvider,
              'itemView' => 'battle.tablerow.tpl',
              'itemOptions' => [ 'tag' => false ],
              'layout' => '{pager}',
              'pager' => [
                'maxButtonCount' => 5
              ]
            ])}}
        </div>
      </div>
      <div class="col-xs-12 col-sm-4 col-md-4 col-lg-3">
        {{BattleFilterWidget route="show/user" screen_name=$user->screen_name filter=$filter}}
        {{include file="@app/views/includes/user-miniinfo.tpl" user=$user}}
        {{AdWidget}}
      </div>
    </div>
  </div>
{{/strip}}
