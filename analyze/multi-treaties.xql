xquery version "3.1";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
import module namespace app="http://www.digital-archiv.at/ns/kongress/templates" at "../modules/app.xql";
declare option exist:serialize "method=xml media-type=text/html indent=yes";

let $query := request:get-parameter('ix', '')
let $indices := $query
let $ix := tokenize($indices, '____')
let $match := collection($app:indices)//id($ix)
let $modal :=
<div class="modal fade" tabindex="-1" role="dialog" id="myModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title">Info</h4>
      </div>
      <div class="modal-body">
        <ul>
            {for $x in $match
                let $xmlId := data($x/@xml:id)
                return 
                    <li>
                        {$x} 
                        <br />
                        <a href="hits.html?searchkey={$xmlId}">alle Erwähnungen</a>
                    </li>
            }
        </ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Schließen</button>
      </div>
    </div>
  </div>
</div>


return $modal