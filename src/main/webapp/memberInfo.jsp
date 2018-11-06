<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8"/>
    <title><c:out value="${member.realName}"/> - 成员信息 - ${short_title}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>

    <!-- bootstrap & fontawesome -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="components/font-awesome/css/font-awesome.css"/>

    <!-- page specific plugin styles -->

    <!-- text fonts -->
    <!--<link rel="stylesheet" href="assets/css/ace-fonts.css"/>-->

    <!-- ace styles -->
    <link rel="stylesheet" href="assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>


    <!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

    <!--[if lte IE 8]-->
    <script src="js/html5shiv/dist/html5shiv.js"></script>
    <script src="js/respond/dest/respond.min.js"></script>
    <!--[endif]-->


    <!-- basic scripts -->

    <!--[if !IE]> -->
    <!--<script src="components/jquery/dist/jquery.js"></script>-->
    <script src="js/jquery-3.2.0.min.js"></script>

    <!-- <![endif]-->

    <!--[if IE]-->
    <!--<script src="components/jquery.1x/dist/jquery.js"></script>-->
    <script src="js/jquery-1.11.3.min.js"></script>
    <!--[endif]-->
    <!--<script src="components/bootstrap/dist/js/bootstrap.js"></script>-->
    <script src="js/bootstrap.min.js"></script>

    <!-- page specific plugin scripts -->


    <!-- static.html end-->

    <script src="js/datatables/jquery.dataTables.min.js"></script>

    <script src="js/datatables/jquery.dataTables.bootstrap.min.js"></script>
    <script src="js/datatables.net-buttons/dataTables.buttons.min.js"></script>
    <script src="js/datatables/dataTables.select.min.js"></script>
    <script src="js/jquery-ui/jquery-ui.min.js"></script>

    <%--<script src="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js"></script>--%>
    <script src="js/accounting.min.js"></script>
    <script src="js/func.js"></script>
    <%--<script src="assets/js/jquery.validate.min.js"></script>--%>
    <%--<script src="../js/messages_cn.js"></script>--%>

    <%--<link href="https://cdn.bootcss.com/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.css" rel="stylesheet">--%>
    <link rel="stylesheet" href="css/jqueryui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="components/jquery-ui.custom/jquery-ui.custom.css"/>


    <script src="assets/js/ace.js"></script>
    <link rel="stylesheet" href="components/zTree_v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.core.js"></script>
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.excheck.js"></script>
    <script type="text/javascript" src="components/zTree_v3/js/jquery.ztree.exedit.js"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            var setting = {
                async: {
                    enable: true,
                    url: "memberZTree.jspx",
                    autoParam: ["id", "name=n", "level=lv"],
                    otherParam: {"otherParam": "zTreeAsyncTest"}/*,
                    dataFilter: filter*/
                },
                callback: {
                    /*onClick: zTreeOnClick
                    ,*/ beforeAsync: beforeAsync,
                    onAsyncSuccess: onAsyncSuccess
                }
            };

            function beforeAsync() {
                curAsyncCount++;
            }

            function onAsyncSuccess(event, treeId, treeNode, msg) {
                curAsyncCount--;
                if (curStatus === "expand") {
                    expandNodes(treeNode.children);
                } else if (curStatus === "async") {
                    asyncNodes(treeNode.children);
                }

                if (curAsyncCount <= 0) {
                    curStatus = "";
                }
            }

            var curStatus = "init", curAsyncCount = 0, goAsync = false;


            function check() {
                return curAsyncCount <= 0;
            }

            function expandNodes(nodes) {
                if (!nodes) return;
                curStatus = "expand";
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                for (var i = 0, l = nodes.length; i < l; i++) {
                    zTree.expandNode(nodes[i], true, false, false);//展开节点就会调用后台查询子节点
                    if (nodes[i].isParent && nodes[i].zAsync) {
                        expandNodes(nodes[i].children);//递归
                    } else {
                        goAsync = true;
                    }
                }
            }

            $('button:first').click(function () {
                if (!check()) {
                    return;
                }
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                expandNodes(zTree.getNodes());
                if (!goAsync) {
                    curStatus = "";
                }
            });

            /* function filter(treeId, parentNode, childNodes) {
                 if (!childNodes) return null;
                 for (var i = 0, l = childNodes.length; i < l; i++) {
                     childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
                 }
                 return childNodes;
             }*/

            $.fn.zTree.init($("#treeDemo"), setting,
                {
                    id: '<c:out value="${member.memberNo}"/>',
                    name: '<c:out value="${member.realName}"/>',
                    isParent:<c:out value="${member.directCount>0}"/>
                });

            var zTree = $.fn.zTree.getZTreeObj("treeDemo");
            zTree.expandNode(zTree.getNodes()[0], true, false, false);//展开节点就会调用后台查询子节点

            var row2 = '<div class="profile-info-row">' +
                '<div class="profile-info-name">{0}</div>' +
                '<div class="profile-info-value">{1}</div>' +
                '<div class="profile-info-name">{2}</div>' +
                '<div class="profile-info-value">{3}</div>' +
                '</div>';
            var row3 = '<div class="profile-info-row">' +
                '<div class="profile-info-name">{0}</div>' +
                '<div class="profile-info-value">{1}</div>' +
                '<div class="profile-info-name">{2}</div>' +
                '<div class="profile-info-value">{3}</div>' +
                '<div class="profile-info-name">{4}</div>' +
                '<div class="profile-info-value">{5}</div>' +
                '</div>';

            var divObject = '<div class="widget-main padding-8" >' +
                '<h5 class="widget-title blue smaller">{0}</h5>' +
                '<div class="profile-user-info profile-user-info-striped">' +
                '{1}' +
                '</div>' +
                '</div>';

            /* function zTreeOnClick(event, treeId, treeNode) {
                 //alert(treeNode.id + ", " + treeNode.name);
                 showMemberInfo(treeNode.id);
             }*/

            function showDivObject(propName, obj) {
                var keyVals = [];
                var kk = 0;
                $.each(obj, function (key, val) {
                    keyVals[kk++] = {'key': key, 'value': val};
                });
                var html = "";
                if (keyVals.length % 3 === 0) {
                    for (kk = 0; kk < keyVals.length; kk += 3)
                        html += row3.format(keyVals[kk].key, keyVals[kk].value,
                            keyVals[kk + 1].key, keyVals[kk + 1].value,
                            keyVals[kk + 2].key, keyVals[kk + 2].value);
                }
                else
                    for (kk = 0; kk < keyVals.length; kk += 2) {
                        if (keyVals[kk + 1])
                            html += row2.format(keyVals[kk].key, keyVals[kk].value, keyVals[kk + 1].key, keyVals[kk + 1].value);
                        else
                            html += row2.format(keyVals[kk].key, keyVals[kk].value, '', '');
                    }
                return divObject.format(propName, html);
            }

            function showTable(propName, obj) {
                var th = "";
                var td = "";
                for (var i = 0; i < obj.length; i++) {
                    var row_td = "";
                    var row_th = "";
                    $.each(obj[i], function (key, val) {
                        if (i === 0)
                            row_th += "<th>{0}</th>".format(key);
                        row_td += "<td>{0}</td>".format(val);
                    });
                    if (i === 0)
                        th = "<thead><tr>{0}</tr></thead>".format(row_th);
                    td += "<tbody><tr>{0}</tr></tbody>".format(row_td);
                }
                var html = '<table border="0" cellspacing="1" cellpadding="0" class="table table-striped table-bordered table-hover">{0}{1}</table>'
                    .format(th, td);
                return divObject.format(propName, html);
            }

            var infoString = '<c:out value="${member.memberInfo}" escapeXml="false"/>';

            showMemberInfo();

            function showMemberInfo() {
                if (infoString !== '') {
                    var memberInfo = JSON.parse(infoString);
                    var baseInfo = {
                        "用户名": '<c:out value="${member.realName}"/>', "手机号码": '<c:out value="${member.phone}"/>',
                        "注册时间": memberInfo["基本信息"]["注册时间"],"上级ID": '<c:out value="${member.parentNo}"/>',
                        "当前层级": '<c:out value="${member.level}"/>', "下级深度": '<c:out value="${member.childDepth}"/>',
                        "全部下级数": '<c:out value="${member.childTotal}"/>', "直接下级数": '<c:out value="${member.directCount}"/>',
                        "二层下级数": '<c:out value="${member.secondCount}"/>'
                    };
                    html = showDivObject("层级信息", baseInfo);
                    $('#baseInfo').html(html);


                    //html = showDivObject("基本信息", memberInfo["基本信息"]);
                    html = showDivObject("资金", memberInfo["资金"]);
                    html += showDivObject("钱包", memberInfo["钱包"]);
                    html += showTable("提现银行卡", memberInfo["提现银行卡"]);
                    html += showTable("登记银行卡", memberInfo["登记银行卡"]);
                    $('#aaa').html(html);

                    /*对含ID的，增加连接*/
                    $('#baseInfo').find(".profile-info-row").each(function () {
                        if ($(this).find('.profile-info-name:eq(0)').text().indexOf("ID") > 0) {
                            var valueElement = $(this).find('.profile-info-value:eq(0)');

                            valueElement.html("<a href='memberInfo.jspx?memberNo={0}'>{1}</a>".format(valueElement.text(), valueElement.text()));
                        }
                        if ($(this).find('.profile-info-name:eq(1)').text().indexOf("ID") > 0) {
                            valueElement = $(this).find('.profile-info-value:eq(1)');

                            valueElement.html("<a href='memberInfo.jspx?memberNo={0}'>{1}</a>".format(valueElement.text(), valueElement.text()));
                        }
                    });
                    //对现金增加连接
                    var $table = $('#aaa').find("table:contains('提现金额')");
                    if ($table.length > 0) {
                        var col1 = $table.find("thead tr th:contains('提现金额')").index();
                        var col2 = $table.find("thead tr th:contains('卡号')").index();

                        $table.find("tbody tr").each(function (index,element){
                            $(element).find("td").eq(col1).html("<a href='memberWithdraw.jspx?bankcard={0}' target='_blank'>{1}</a>"
                                .format($(element).find("td").eq(col2).text(),$(element).find("td").eq(col1).text()));
                        });
                    }
                    var $div = $('#aaa').find("div.profile-user-info:contains('钱包')");
                    //console.log('div length:' + $div.length);
                    if ($div.length > 0) {
                        var purse_len = $div.find(".profile-info-value").length;
                        for (var k = 0; k < purse_len; k++)
                            if ($div.find(".profile-info-value").eq(k).text() > 0) {
                                //console.log($div.find(".profile-info-value").eq(k).text());
                                $div.find(".profile-info-value").eq(k).html("<a href='memberIntegral.jspx?memberNo={0}&purseName={1}' target='_blank'>{2}</a>"
                                    .format(<c:out value="${member.memberNo}"/>,
                                        encodeURI(encodeURI($div.find(".profile-info-name").eq(k).text())),
                                        $div.find(".profile-info-value").eq(k).text()));
                            }

                    }
                }
                $(".profile-info-name:contains('提现金额')").css("width", "200px");
                $(".profile-info-name:contains('用户名')").next().addClass("bigger-150");
                $(".profile-info-name:contains('手机号码')").next().addClass("bigger-130");
                // });

            }

            /* $('button:last').click(function () {
                 $(window).attr('location', 'member.jspx');
             });*/
        })
    </script>
</head>
<body class="no-skin">
<div class="main-container ace-save-state" id="main-container">
    <script type="text/javascript">
        try {
            ace.settings.loadState('main-container')
        } catch (e) {
        }
    </script>
    <div class="main-content">
        <div class="main-content-inner">

            <div class="page-content">
                <div class="row">
                    <div class="col-xs-12">
                        <!-- PAGE CONTENT BEGINS -->

                        <!-- #section:plugins/zTree -->
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="widget-box widget-color-blue2">
                                    <div class="widget-header">
                                        <h4 class="widget-title  smaller">
                                            <c:out value="${member.realName}"/> -<span class="smaller-80">
                                            当前层级：<c:out value="${member.level}"/>
                                            下级深度：<c:out value="${member.childDepth}"/>
                                            全部下级数：<c:out value="${member.childTotal}"/>
                                            直接下级数：<c:out value="${member.directCount}"/>
                                            二层下级数：<c:out value="${member.secondCount}"/> </span>
                                        </h4>
                                        <button class="btn btn-warning btn-xs pull-right" id="expandTree">
                                            <i class="ace-icon  fa fa-folder-open-o  bigger-110 icon-only"></i>
                                            全部展开
                                        </button>
                                    </div>

                                    <div class="widget-body">
                                        <div class="widget-main padding-8">
                                            <div class="zTreeDemoBackground left">
                                                <ul id="treeDemo" class="ztree"></ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-sm-6">
                                <div class="widget-box widget-color-green2">
                                    <div class="widget-header">
                                        <h4 class="widget-title      smaller">
                                            成员详细信息
                                            <span class="smaller-80"></span>
                                        </h4>
                                    </div>

                                    <div class="widget-body">
                                        <!-- #section:pages/profile.info -->
                                        <div id="baseInfo">

                                        </div>
                                        <!-- /section:pages/profile.info -->
                                        <div id="aaa"></div>
                                        <%-- <div class="widget-main padding-8">
                                             提示：点击用户ID、上级，可以查看该ID的成员信息。
                                         </div>--%>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- /section:plugins/zTree -->

                        <!-- PAGE CONTENT ENDS -->
                    </div><!-- /.col -->
                </div><!-- /.row -->

            </div><!-- /.page-content -->
        </div><!-- /.main-container-inner -->
    </div><!-- /.main-content -->
    <div class="footer">
        <div class="footer-inner">
            <!-- #section:basics/footer -->
            <div class="footer-content">
                <span class="bigger-120"><span class="blue bolder">广东鑫证</span>司法鉴定所 &copy; 2018
                </span>
            </div>
            <!-- /section:basics/footer -->
        </div>
    </div>
</div><!-- /.main-container -->

</body>
</html>