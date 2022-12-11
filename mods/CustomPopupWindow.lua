function showPopMenu(tab,views,title)
  lp = activity.getWindow().getAttributes();
  lp.alpha = 0.85;
  activity.getWindow().setAttributes(lp);
  activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);

  Popup_layout={
    LinearLayoutCompat;
    {
      MaterialCardView;
      Elevation="0";
      CardBackgroundColor=backgroundc;
      Radius="18dp";
      layout_width="192dp";
      layout_height="-2";
      layout_marginTop="8dp";
      layout_marginLeft="8dp";
      {
        LinearLayoutCompat;
        layout_height="-1";
        layout_width="-1";
        orientation="vertical",
        id="Popup_list";
      };
    };
  };

  --PopupWindow
  pops=PopupWindow(activity)
  --PopupWindow加载布局
  .setContentView(loadlayout(Popup_layout))
  .setWidth(-2)
  .setHeight(-2)
  .setFocusable(true)
  .setOutsideTouchable(true)
  .setBackgroundDrawable(ColorDrawable(0x00000000))

  pops.onDismiss=function()
    lp = activity.getWindow().getAttributes();
    lp.alpha = 1;
    activity.getWindow().setAttributes(lp);
    activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_DIM_BEHIND);
  end

  --PopupWindow列表项布局
  Popup_list_title={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="48dp";
    {
      MaterialTextView;
      id="popadp_text";
      Typeface=Typeface.DEFAULT_BOLD,
      textColor=tertiaryc;
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
      Enabled=false,
      --Alpha=0.5,
    };
  };

  if title
    view=loadlayout(Popup_list_title)
    Popup_list.addView(view)
    popadp_text.setText(title)
  end

  Popup_list_item={
    LinearLayoutCompat;
    layout_width="-1";
    layout_height="48dp";
    backgroundColor=backgroundc,
    {
      MaterialTextView;
      id="popadp_text";
      layout_width="-1";
      layout_height="-1";
      textSize="14sp";
      gravity="left|center";
      paddingLeft="16dp";
    };
  };

  for k,v in pairs(tab)

    view=loadlayout(Popup_list_item)
    view.backgroundResource=rippleRes.resourceId;
    if type(v)=="table"

      Popup_list.addView(view)
      popadp_text.setText(k.."...")
      view.onClick=function()
        pops.dismiss()
        task(50,function()

          showPopMenu(v,views,k.."...")
        end)
        -- pops.dismiss()
      end

     elseif type(v)=="function"

      Popup_list.addView(view)
      popadp_text.setText(k)
      view.onClick=function()
        pops.dismiss()
        task(50,function()

          v()
        end)
      end
    end
  end
  pops.showAsDropDown(views)
end

