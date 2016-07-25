// All material copyright ESRI, All Rights Reserved, unless otherwise specified.
// See http://js.arcgis.com/3.17/esri/copyright.txt for details.
//>>built
define("esri/tasks/datareviewer/_DRSBaseTask","dojo/_base/declare dojo/_base/lang dojo/_base/array dojo/Deferred dojo/has ../../request ../../urlUtils ../../kernel ../Task ./ReviewerSession".split(" "),function(k,f,p,l,s,n,q,t,u,r){k=k(u,{declaredClass:"esri.tasks.datareviewer.DRSBaseTask",_url:null,_queryParams:null,_reviewerMapServerUrl:null,constructor:function(a){"/"==a[a.length-1]&&(a=a.slice(0,-1));a=q.urlToObject(a);this._url=a.path;this._queryParams=a.query;a=this._url.toLowerCase().lastIndexOf("/exts/");
0<a&&(this._reviewerMapServerUrl=this._url.substring(0,a));this._successHandler=f.hitch(this,this._successHandler);this._errorHandler=f.hitch(this,this._errorHandler);this._appendQueryParams=f.hitch(this,this._appendQueryParams);this.onError=f.hitch(this,this.onError)},_appendQueryParams:function(a){if(this._queryParams)for(var b in this._queryParams)a=q.urlToObject(a).query?a+("\x26"+b+"\x3d"+this._queryParams[b]):a+("?"+b+"\x3d"+this._queryParams[b]);return a},_successHandler:function(a,b,g){b&&
this[b].apply(this,[a]);g&&g.resolve(a)},_errorHandler:function(a,b){null===a&&(a=Error("Unexpected response received from server"),a.code=500);this.onError(a);b&&b.reject(a)},getReviewerMapServerUrl:function(){var a=null;if(a=this._reviewerMapServerUrl){if(this._queryParams)for(var b in this._queryParams)a=q.urlToObject(a).query?a+("\x26"+b+"\x3d"+this._queryParams[b]):a+("?"+b+"\x3d"+this._queryParams[b]);return a}return null},getLifecycleStatusStrings:function(){var a=this._successHandler,b=this._errorHandler,
g=this._appendQueryParams,c=this._url+"/Utilities/getLifecycleStatusStrings",c=g(c),e=new l;n({callbackParamName:"callback",url:c,content:{f:"json"}}).then(f.hitch(this,function(d,h){if(void 0!==d.error){var m=Error();m.message=d.error.message;m.code=d.error.code;b(m,e)}else try{if(m=d.lifecycleStatusString,void 0===m)b(null,e);else{var c=[];p.forEach(m,function(a,b){c[a.descriptionCode]=a.descriptionString});a({lifecycleStatusStrings:c},"onGetLifecycleStatusStringsComplete",e)}}catch(v){b(v,e)}}),
function(a,h){b(a,e)});return e},createReviewerSession:function(a,b){var g=this._successHandler,c=this._errorHandler,e=this._appendQueryParams,d=this._url+"/Utilities/createReviewerSession",d=e(d),h=new l;n({callbackParamName:"callback",url:d,content:{sessionName:a,sessionProperties:b.toJsonSessionOptions(),f:"json"}}).then(f.hitch(this,function(a,b){if(void 0!==a.error){var d=Error();d.message=a.error.message;d.code=a.error.code;c(d,h)}else try{if(void 0===a.sessionAttributes)c(null,h);else{var d=
a.sessionAttributes,e=new r(d.sessionId,d.sessionName,d.userName,d.versionName);g({reviewerSession:e},"onCreateReviewerSessionComplete",h)}}catch(f){c(f,h)}}),function(a,b){c(a,h)});return h},getReviewerSessions:function(){var a=this._successHandler,b=this._errorHandler,g=this._appendQueryParams,c=this._url+"/Utilities/getReviewerSessions",c=g(c),e=new l;n({callbackParamName:"callback",url:c,content:{f:"json"}}).then(f.hitch(this,function(d,h){if(void 0!==d.error){var c=Error();c.message=d.error.message;
c.code=d.error.code;b(c,e)}else try{if(c=d.sessionAttributes,void 0===c)b(null,e);else{var f=[];p.forEach(c,function(a,b){f[b]=new r(a.sessionId,a.sessionName,a.userName,a.versionName)});a({reviewerSessions:f},"onGetReviewerSessionsComplete",e)}}catch(g){b(g,e)}}),function(a,c){b(a,e)});return e},getCustomFieldNames:function(){var a=this._successHandler,b=this._errorHandler,g="BATCHJOBCHECKGROUP CHECKTITLE FEATUREOBJECTCLASS LIFECYCLEPHASE LIFECYCLESTATUS SESSIONID SEVERITY SUBTYPE".split(" "),c=
this._appendQueryParams,e=this._url+"/Dashboard",e=c(e),d=new l;n({callbackParamName:"callback",url:e,content:{f:"json"}}).then(f.hitch(this,function(c,e){if(void 0!==c.error){var f=Error();f.message=c.error.message;f.code=c.error.code;b(f,d)}else try{var k=[];void 0===c.reviewerResultsBy&&b(null,d);p.forEach(c.reviewerResultsBy,function(a,b){-1===g.indexOf(a.name)&&k.push(a.name)});a({customFieldNames:k},"onGetCustomFieldNamesComplete",d)}catch(l){b(l,d)}}),function(a,c){b(a,d)});return d},onGetLifecycleStatusStringsComplete:function(a){},
onGetReviewerSessionsComplete:function(a){},onCreateReviewerSessionComplete:function(a){},onGetCustomFieldNamesComplete:function(a){},onError:function(a){}});s("extend-esri")&&f.setObject("tasks.datareviewer.DRSBaseTask",k,t);return k});