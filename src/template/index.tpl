<html>
    <head>
        {block 'head'}
            <title>Stitcher</title>
            {meta}
            {css src="main.scss" inline=true}
        {/block}
    </head>
    <body>
        {block 'body'}
            {block 'header'}
                <header>
                    <nav class="wrapper">
                        <a href="/" class="stitcher">Stitcher</a>
                        <a href="/guide">Guide</a>
                        <a href="/examples">Example blog</a>
                    </nav>
                </header>
            {/block}

            <div class="wrapper">
                {block 'content'}{/block}
            </div>

            {block 'footer'}{/block}

            {block 'scripts'}{/block}
        {/block}
    </body>
</html>
