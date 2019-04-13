$(function()
{
    window.addEventListener('message', function(event)
    {
        var item = event.data;
        var buf = $('#wrap');
        buf.find('table').append("<h1 class=\"heading\">GENERATIONEN ROLEPLAY</h1><img class='image' src='https://cdn.pixabay.com/photo/2017/03/17/05/20/info-2150938_640.png'><p id='website'>WWW.GENERATIONENRP.SE</p><p id='discord'>Discord.gg/S5rR9cE</p>");
        if (item.meta && item.meta == 'close')
        {
            document.getElementById("ptbl").innerHTML = "";
            $('#wrap').hide();
            return;
        }
        buf.find('table').append(item.text);
        $('#wrap').show();
    }, false);
});