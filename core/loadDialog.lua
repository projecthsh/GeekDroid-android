
SelectDownload.onClick=function()
  local onSelectLayout=
  {
    LinearLayoutCompat,
    orientation="vertical",
    layout_width="match_parent";
    padding="20dp",
    {
      TextInputEditText;
      layout_width="match_parent";
      layout_gravity="center",
      tooltipText="输入下载路径",
      text=sp.getString("FileAddress",""),
      id="downloadEdit";
    },
    {
      MaterialTextView,
      layout_marginTop="10dp",
      tooltipText=sp.getString("FileAddress",""),
      text="当前路径为"..sp.getString("FileAddress","").."\n仅支持下载到Android内部存储\n\n对于Android10以上用户建议通过SAF进一步授予对应文件夹权限",
    },
    {
      MaterialTextView,
      layout_marginTop="10dp",
      text="点击此处打开SAF框架",
      textColor=primaryColor,
      backgroundResource=rippleRes.resourceId,
      Typeface=Typeface.defaultFromStyle(Typeface.BOLD);
      onClick=function()
        import{
          "android.provider.DocumentsContract",
          "androidx.documentfile.provider.DocumentFile",
        }
        uri=Uri.parse("content://com.android.externalstorage.documents/tree/primary%3A")
        intent=Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION|Intent.FLAG_GRANT_WRITE_URI_PERMISSION|Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION|Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
        intent.putExtra(DocumentsContract.EXTRA_INITIAL_URI,DocumentFile.fromTreeUri(activity,uri).getUri())
        activity.startActivity(intent)
      end,
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("文件下载路径")
  .setView(loadlayout(onSelectLayout))
  .setPositiveButton("确定",function()
    hideInput(downloadEdit)
    SelectDownload.getChildAt(0).getChildAt(1).setText("当前下载路径"..sp.getString("FileAddress",""))
  end)
  .show()
  downloadEdit.addTextChangedListener{
    onTextChanged=function()
      dataInput(tostring(downloadEdit.getText()),"settings","FileAddress")
    end
  }
end
contactLinear.onClick=function()
  local onContactLayout=
  {
    LinearLayoutCompat,
    orientation="vertical",
    layout_width="match_parent";
    padding="20dp",
    {
      MaterialTextView,
      layout_width="match_parent";
      layout_Padding="10dp",
      text="TeleGram交流群:geekdroid_group",
      textColor=primaryColor,
      backgroundResource=rippleRes.resourceId,
      textStyle="bold",
      textSize="16sp",
      onClick=function()
        local url="https://t.me/geekdroid_group"
        viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
        activity.startActivity(viewIntent)
      end,
    },
    {
      MaterialTextView,
      layout_width="match_parent";
      layout_Padding="10dp",
      text="QQ交流群:740536446",
      textColor=primaryColor,
      backgroundResource=rippleRes.resourceId,
      textStyle="bold",
      textSize="16sp",
      onClick=function()
        local _l="mqqapi://card/show_pslcard?src_type=internal&version=1&uin=740536446&card_type=group&source=qrcode"
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(_l)))
      end,
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("项目交流")
  .setView(loadlayout(onContactLayout))
  .setPositiveButton("确定",nil)
  .show();
end

licenseShow.onClick=function(v)
  local MarkDownLayout=
  {
    LinearLayoutCompat,
    layout_width="match_parent";
    padding="12dp";
    {
      MaterialCardView,
      radius="16dp",
      layout_width="match_parent";
      {
        LuaWebView;
        id="WebView";
        layout_width="-1";
        layout_height="-1";
        ProgressBarEnabled=false,
      },
    },
  }
  MaterialAlertDialogBuilder(this)
  .setTitle("开源许可")
  .setView(loadlayout(MarkDownLayout))
  .setPositiveButton("确定",nil)
  .show()
  --设置WebView显示动画
  YoYo.with(Techniques.FadeIn).duration(1000).playOn(WebView)
  --rawio获取md内容
  local Markdown4jProcessor=luajava.bindClass("org.markdown4j.Markdown4jProcessor")
  local content = rawio.iotsread(activity.getLuaDir().."/license.md","r")
  WebView.loadDataWithBaseURL("",Markdown4jProcessor().process(content),"text/html","utf-8",nil)
  function isNightMode()
    local configuration = activity.getResources().getConfiguration();
    return configuration.uiMode+1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode-1==configuration.UI_MODE_NIGHT_YES or configuration.uiMode==configuration.UI_MODE_NIGHT_YES
  end
  WebView.setWebViewClient({
    onPageFinished = function(view,url)
      if isNightMode() then
        WebView.evaluateJavascript([[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#212121 !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]],nil)
       else
      end
    end,
    shouldOverrideUrlLoading=function(view,url)
      local intent = Intent()
      intent.setAction("android.intent.action.VIEW")
      local content_url = Uri.parse(url)
      intent.setData(content_url)
      activity.startActivity(intent)
      return true
    end
  })
  WebView.onLongClick = function()
    return true
  end
end

documentShow.onClick=function(v)
  MaterialAlertDialogBuilder(this)
  .setTitle("使用协议和隐私政策")
  .setMessage(getPrivatePrivacy())
  .setPositiveButton("确定",nil)
  .show()
end