(function() {
    //生成订单
    //确认订单的表单提交时绑定事件
    $('.create-order-form').submit(function() {
        var addressID = $('input[name="address_id"]:checked').val(),
            $form = $(this);
        //没有选择收货地址
        if (!addressID) {
            alert("请选择收货地址!");
            return false;//取消表单提交
        } else {
            //把收货地址放在表单中
            $form.find('input[name="address_id"]').val(addressID);
            return true;//提交当前表单
        }
    })

    //地址，绑定了四个事件，在document上边
    //为页面上所有带有 .new-address-btn 类的按钮添加了一个点击事件处理程序。当用户点击这样的按钮时，
    // 它会通过 AJAX 请求获取一个新的地址表单，然后将其添加到页面上，并显示一个模态框（modal）。
    $(document).on('click', '.new-address-btn', function() {
        // AJAX GET 请求，它获取 /addresses/new URL 的内容。这个URL应该返回一个新的地址表单
        $.get('/addresses/new', function(data) {
            // 检查页面上是否有 id 为 address_form_modal 的元素。
            // 如果有，就将其从页面中移除。这确保不会多次添加相同的模态框
            if ($('#address_form_modal').length > 0) {
                $('#address_form_modal').remove();
            }
            //将获取到的新地址表单内容添加到页面的 body 部分
            $('body').append(data);
            //显示新添加的模态框
            $('#address_form_modal').modal();
        })
        //阻止点击事件的默认行为
        return false;
    })
        // 监听所有 class 为 address-form 的元素的 AJAX 成功事件
        .on('ajax:success', '.address-form', function(e, data) {
            if (data.status === 'ok') { //成功则把modal弹出窗口关掉
                $('#address_form_modal').modal('hide');
                //更新地址列表页面
                $('#address_list').html(data.data);
            } else {
                //验证没有通过，直接把表单内容显示(包含模型上的错误信息)
                $('#address_form_modal').html($(data.data).html());
            }
        })
        //编辑当前收货地址
        .on('ajax:success', '.edit-address-btn', function(e, data) {
            if ($('#address_form_modal').length > 0) {
                $('#address_form_modal').remove();
            }

            $('body').append(data);
            $('#address_form_modal').modal();
        })
        //都是异步请求，成功后更新当前地址列表页面
        .on('ajax:success', '.set-default-address-btn, .remove-address-btn', function(e, data) {
            $('#address_list').html(data.data);
        })

    //购物车
    //为所有具有add-to-cart-btn类名的元素绑定一个点击事件处理程序
    $('.add-to-cart-btn').click(function() {
        var $this = $(this),
            $amount = $('input[name="amount"]'),
            //在$this(被点击的按钮内查找<i>标签元素)
            $prog = $this.find('i');
        //判断名为amount的输入框，若值小于等于0，则弹出警告窗口
        if ($amount.length > 0 && parseInt($amount.val()) <= 0) {
            alert("购买数量至少为 1");
            return false;
        }

        //发起异步HTTP请求
        $.ajax({
            //从被点击的按钮上获取href值作为请求的URL
            url: $this.attr('href'),
            method: 'post', //请求方法为POST
            //将产品ID和数量作为请求体发送
            data: { product_id: $this.data('product-id'), amount: $amount.val() },
            //发送请求之前执行，检查<i>元素是否具有fa-spin类，没有则添加并显示
            beforeSend: function() {
                if (!$prog.hasClass('fa-spin')) {
                    $prog.addClass('fa-spin');
                }
                $prog.show();
            },
            //请求成功后的回调函数，先检查页面上是否有ID为shopping_cart_modal的元素，有则移除
            success: function(data) {
                if ($('#shopping_cart_modal').length > 0) {
                    $('#shopping_cart_modal').remove();
                }

                $('body').append(data);
                $('#shopping_cart_modal').modal();
            },
            //无论请求成败都会执行，隐藏<i>元素
            complete: function() {
                $prog.hide();
            }
        })

        return false;
    })

})()