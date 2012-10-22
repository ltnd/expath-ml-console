xquery version "3.0";

import module namespace v   = "http://expath.org/ns/ml/console/view"   at "../lib/view.xql";
import module namespace t   = "http://expath.org/ns/ml/console/tools"  at "../lib/tools.xql";
import module namespace a   = "http://expath.org/ns/ml/console/admin"  at "../lib/admin.xql";
import module namespace cfg = "http://expath.org/ns/ml/console/config" at "../lib/config.xql";

declare default element namespace "http://www.w3.org/1999/xhtml";

declare namespace c    = "http://expath.org/ns/ml/console";
declare namespace err  = "http://www.w3.org/2005/xqt-errors";
declare namespace h    = "http://www.w3.org/1999/xhtml";
declare namespace xdmp = "http://marklogic.com/xdmp";

(:
 : TODO: Maintain a list of deleted repositories (but the content of which has
 : not been removed, either on DB or FS), in order to keep track of them for
 : the user...?  There sould then be a way for the user to ask to forget about
 : one specific such reminder...
 :)

(: TODO: Check the parameter has been passed, to avoid XQuery errors! :)
(: (turn it into a human-friendly error instead...) :)
(: And validate it! (does the repo exist?) :)
let $repo    := t:mandatory-field('repo')
let $delete  := xs:boolean(t:optional-field('delete', 'false'))
let $confirm := xs:boolean(t:optional-field('confirm', 'false'))
return
   v:console-page(
      'repo',
      'Repositories',
      '../',
      (
         if ( not($confirm) ) then
            <p>
               <span>Are you sure you want to delete  repo '{ $repo }': </span>
               <a href="delete.xq?repo={ $repo }&amp;delete={ $delete }&amp;confirm=true">Yes</a>
               <span> / </span>
               <a href="../repo.xq">No</a>
            </p>
         else
            try {
               cfg:forget-repo($repo, $delete),
               <p>The repository '{ $repo }' has been successfully removed.</p>
            }
            catch c:* {
               <p><b>Error</b>: { $err:description }</p>
            },
         <p>Back to <a href="../repo.xq">repositories</a>.</p>
      ))
