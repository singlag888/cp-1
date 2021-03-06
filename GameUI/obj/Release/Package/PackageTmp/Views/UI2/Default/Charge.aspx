﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/UI2/Default/Common/PageDefault.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server"></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<script type="text/javascript" src="/Scripts/Clipboard/jquery.zclip.js"></script>
    <link rel="stylesheet" type="text/css" href="/CSS/ZJ2/UI/jqueryui_base/jquery.ui.all.css">
<%
    var methodType = (string)ViewData["MethodType"];
    var ctList = (List<DBModel.wgs009>)ViewData["CTList"];
    var dicBankList = (Dictionary<int, DBModel.wgs010>)ViewData["BankDicList"];
    var ctListOrd = from a in ctList from b in dicBankList where a.sb001 == b.Value.sb001 orderby b.Value.sb009 select a;
%>
<div class="m_body_bg">
<div class="main_box main_tbg">
<div class="main_table_bg">
<div class="main_table_box">
    <div class="user_info_tab hd">
        <ul>
            <span><a class="info_close" href="#"></a></span>
             <li class="on"><a href="/UI2/Charge" <%=methodType == "crhl" ? "class='item-select'" : "" %>>充值</a></li>
        </ul>
    </div>
<form action="/UI2/Charge" method="post" id="form_charge">
<%:Html.AntiForgeryToken() %>
<input type="hidden" name="target" value="check" />
<div class="bank_list">
    <table class="ctable_box ctable_box1" width="100%" border="0" cellpadding="0" cellspacing="0">
        <tbody >
          <tr>
            <td style="border-top:1px solid #dad8c5">充值类型</td>
            <td style="text-align:left;border-top:1px solid #dad8c5" ><%
                var selectIndex = 0;
                foreach (var item in ctListOrd)
                {
                    %>
            <label for="ct<%:item.ct001 %>" style="margin-right: 5px;" title="<%:dicBankList[item.sb001].sb003 %>">
                <input id="ct<%:item.ct001 %>" type="radio" name="charge_type" <%if(selectIndex==0) {%> checked="checked"<%} %> value="<%:item.ct001 %>" /><%:dicBankList[item.sb001].sb003 %></label>
            <%
                    selectIndex += 1;
            } %></td>
        </tr>
          <%if( "1" == (string)ViewData["NCWVCode"]){ %>
            <tr>
                <td class="title">验证码</td>
                <td style="text-align:left"><input class="cw_vcode cvc h-point" type="text" style="width:150px; height:50px; border:none;" readonly="readonly" /><br /><span class="cvc h-point">[换一张]</span><br /><input type="text" class="input-text w200px" name="cw_vcode" value="" /></td>
            </tr>
            <%} %>
            <tr>
                <td class="title">资金密码</td>
                <td style="text-align:left">
                    <input type="password" class="input-text w200px" name="char_password" value="" /></td>
            </tr>
<%--            <tr>
                <td class="title"></td>
                <td class="cn-money fs16px" style="text-align:left"></td>
            </tr>--%>
            <tr>
                <td class="title">充值金额</td>
                <td style="text-align:left">
                    <input type="text" class="input-text w200px fc-yellow" id="cg-money" name="charge_amount" value="<%=ViewData["CMIN"] %>" /><%=ViewData["CMINDEST"] %></td>
            </tr>
            <tr>
                <td class="title"></td>
                <td style="text-align:left">
                    <input id="btn_charge" type="button" class="btn-normal" value="确认" /></td>
            </tr>
    </tbody></table>
</div>
</form>
<%=ViewData["SysChargeComment"] %>

<div id="dlg_charge_info" class="dom-hide" style="display:none">
    <table class="table-pro charge_dialog_w">
        <tr>
            <td class="title">收款银行</td>
            <td class="s_bn"></td>
            <td id="s_bn_copy"></td>
        </tr>
        <tr>
            <td class="title">充值金额</td>
            <td class="s_am"></td>
            <td id="s_am_copy"></td>
        </tr>
        <tr>
            <td class="title">收款账号</td>
            <td class="s_acct">点击右边复制即可</td>
            <td id="s_acct_copy"></td>
        </tr>
        <tr>
            <td class="title">收款人</td>
            <td class="s_mg">点击右边复制即可</td>
            <td id="s_mg_copy"></td>
        </tr>
        <tr>
            <td class="title">开户行</td>
            <td class="s_ob">点击右边复制即可</td>
            <td id="s_ob_copy"></td>
        </tr>
        <tr class="s_yz">
            <td class="title">付款银行卡</td>
            <td><input type="text" class="input-text s_pay_card" name="s_pay_card" /></td>
            <td>农业银行</td>
        </tr>
        <tr class="s_yz">
            <td class="title">付款卡开户名</td>
            <td><input type="text" class="input-text s_pay_name" name="s_pay_name" /></td>
            <td>农业银行</td>
        </tr>
        <tr class="s_normal">
            <td class="title">充值码</td>
            <td class="s_oid">点击右边复制即可</td>
            <td id="s_oid_copy" title="附言、转账用途、备注" style="text-decoration:underline;">附言（必填，否则不到账）
                <div id="x_left_block">
                    <hr />
                    <p>剩余时间：<span id="x_left_time"></span></p>
                    <p>必须在允许时间段内充值完成</p>
                </div>
            </td>
        </tr>
        <tr class="s_yz">
            <td class="title">充值码</td>
            <td><input type="text" class="input-text s_pay_number" name="s_pay_number" /></td>
            <td title="附言、转账用途、备注" style="text-decoration:underline;">？附言（必填，否则不到账）</td>
        </tr>
        <tr id="pay_site">
            <td class="title">网址</td>
            <td><a id="a_go_url" href="#" target="_blank" title="去支付">>>去支付</a></td>
            <td></td>
        </tr>
    </table>
</div>

<script type="text/javascript">
    function set_charge_code() {
        $(".cw_vcode").css("background-image", "url(/UI/CWVCode?r=" + Math.random() + ")");
    }


    $(document).ready(function () {
        set_charge_code();

        $(".cvc").click(function () { set_charge_code(); });
        $("#cg-money").keyup(function () { $(".cn-money").html(_global_D2B($(this).val())); });
        $("#pay_site").hide();
        $("#btn_charge").click(function () {
            var form_data = $("#form_charge").serialize();
            $.ajax({
                async: false, timeout: _global_ajax_timeout, type: "POST", cache: false, url: "/UI2/Charge", data: form_data, dataType: "json",
                success: function (a, b) {
                    _check_auth(a);
                    if (0 == a.Code) {
                        alert(a.Message);
                    }
                    else if (1 == a.Code) {
                        var encodeInfo = a.Data.EncodeInfo;
                        var select_type = $('input:radio[name="charge_type"]:checked').val();
                        if (10 == select_type) {
                            window.open("/UI/Charge?method=dinpayBank&key=" + a.Data.ChargeCode, null, "fullscreen＝yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes");
                            //window.parent.parent.ui_show_tab('在线支付', "/UI/Charge?method=dinpayBank&key=" + a.Data.ChargeCode, true);

                            window.parent.parent._g_js_call("<%=ViewData["CHARGE_ADDESS"]%>/UI2/Charge?method=dinpayBank&key=" + a.Data.ChargeCode);
                        }
                        else if (12 == select_type) {
                            window.open("/UI/Charge?method=yeepay&key=" + a.Data.ChargeCode, null, "fullscreen＝yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes");
                            //window.parent.parent.ui_show_tab('在线支付', "/UI/Charge?method=yeepay&key=" + a.Data.ChargeCode, true);

                            window.parent.parent._g_js_call("<%=ViewData["CHARGE_ADDESS"]%>/UI2/Charge?method=yeepay&key=" + a.Data.ChargeCode);

                        }
                        else if (17 == select_type) {
                            window.open("/UI2/Charge?method=ipspay&key=" + a.Data.ChargeCode, null, "fullscreen＝yes,status=yes,toolbar=no,menubar=no,location=no,resizable=yes");
                            //window.parent.parent.ui_show_tab('在线支付', "/UI/Charge?method=ipspay&key=" + a.Data.ChargeCode, true);

                            window.parent.parent._g_js_call("<%=ViewData["CHARGE_ADDESS"]%>/UI2/Charge?method=ipspay&key=" + a.Data.ChargeCode);

                        }
                        else {
                            $(".s_yz").hide();
                            $("#x_left_block").hide();
                            //_global_ui("dlg_charge_info", 0, 30, 10, 0, "您好，请根据下表中信息进行充值");
                            if (/农业/.test(a.Data.BankName)) {
                                $("#x_left_block").show();
                                $("#x_left_time").html(a.Data.MaxTime);
                            }
                            $("#dlg_charge_info").dialog({ width: 600, title: "您好，请根据下表中信息进行充值", modal: true, resizable: false, position: { my: "center", at: "center", of: window } });
                            $("td.s_bn").attr("hdata", a.Data.BankName);
                            $("td.s_bn").html(a.Data.BankName);
                            $("td.s_am").attr("hdata", a.Data.Amount);
                            $("td.s_am").html(a.Data.Amount);
                            $("td.s_acct").attr("hdata", a.Data.BankAccount);
                            $("td.s_acct").html(a.Data.BankAccount);
                            $("td.s_mg").attr("hdata", a.Data.BankUserName);
                            $("td.s_mg").html(a.Data.BankUserName);
                            $("td.s_ob").attr("hdata", a.Data.BankLocation);
                            $("td.s_ob").html(a.Data.BankLocation);
                            $("td.s_oid").attr("hdata", a.Data.OrderID);
                            $("td.s_oid").html(a.Data.OrderID);
                            if (a.Data.ToURL != "NONE") {
                                $("#pay_site").show();
                                $("#a_go_url").attr("href", a.Data.ToURL);
                            }
                            /*$("#s_bn_copy").html('<input type="button" id="s_bn" value="复制" />');
                            $("#s_bn").zclip({
                                path: "/Scripts/Clipboard/ZeroClipboard.swf",
                                copy: $("td.s_bn").attr("hdata")
                            });*/
                            //$("#s_am_copy").html('<input type="button" id="s_am" value="复制" />');
                            //$("#s_am").zclip({
                            //    path: "/Scripts/Clipboard/ZeroClipboard.swf",
                            //    copy: $("td.s_am").attr("hdata")
                            //});
                            //$("#s_acct_copy").html('<input type="button" id="s_acct" value="复制" />');
                            //$("#s_acct").zclip({
                            //    path: "/Scripts/Clipboard/ZeroClipboard.swf",
                            //    copy: $("td.s_acct").attr("hdata")
                            //});
                            //$("#s_mg_copy").html('<input type="button" id="s_mg" value="复制" />');
                            //$("#s_mg").zclip({
                            //    path: "/Scripts/Clipboard/ZeroClipboard.swf",
                            //    copy: $("td.s_mg").attr("hdata")
                            //});
                            //$("#s_ob_copy").html('<input type="button" id="s_ob" value="复制" />');
                            //$("#s_ob").zclip({
                            //    path: "/Scripts/Clipboard/ZeroClipboard.swf",
                            //    copy: $("td.s_ob").attr("hdata")
                            //});
                            //$("#s_oid_copy").html('<input type="button" id="s_oid" value="复制" />');
                            //$("#s_oid").zclip({
                            //    path: "/Scripts/Clipboard/ZeroClipboard.swf",
                            //    copy: $("td.s_oid").attr("hdata")
                            //});
                        }
            }
                },
                complete: function (a, b) {
                    //alert(b);
                    ui_mask_panel_close();
                    set_charge_code();
                }
            });
        });
    });
</script>
</div></div></div></div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
