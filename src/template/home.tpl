{extends 'index.tpl'}

{block 'head' append}
    {css src='css/home.scss' inline=true}
{/block}

{block 'header'}{/block}

{block 'body'}
    <div class="heading">
        <h2>
            Welcome to Stitcher
        </h2>
        <h3>
            <em>High performance, static websites for PHP developers.</em>
        </h3>

        <div class="vwrapper">
            <a class="button" href="/guide" target="_blank">Getting started</a>
            <em class="button-link">or</em>
            <a class="button" href="/examples" target="_blank">Example blog</a>
        </div>
    </div>
{/block}
