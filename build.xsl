<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://docbook.org/ns/docbook"
    xmlns:ajs="http://www.andrewsales.com/xslt" exclude-result-prefixes="#all" version="3.0">

    <xsl:output method="html" version="5.0"/>

    <xsl:variable name="margin-note-symbol" select="'&#x2295;'"/>
    <!-- CIRCLED PLUS -->

    <xsl:template match="/">
        <xsl:apply-templates select="book/chapter"/>
    </xsl:template>

    <xsl:template match="chapter" mode="nav">
        <li>
            <a href="{@xml:id}.html">
                <xsl:value-of select="@label"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:result-document href="{@xml:id}.html" method="html">
            <html>
                <head>
                    <title><xsl:value-of select="/book/info/title"/></title>
                    <link rel="stylesheet" href="tufte.css"/>
                    <link rel="stylesheet" href="custom.css"/>
                </head>
                <body>
                    <header>
                        <nav>
                            <ul class="navigation">
                                <xsl:apply-templates select="../chapter" mode="nav"/>
                            </ul>
                        </nav>
                        <xsl:apply-templates select="/book/info/cover/mediaobject"/>
                    </header>
                    <article>
                        <xsl:apply-templates/>
                    </article>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="book/info/cover/mediaobject">
        <a href="about.html#logo" class="no-tufte-underline">
            <img src="{imageobject/imagedata/@fileref}" class="{imageobject/@role}"
                alt="{textobject/para}"/>
        </a>
    </xsl:template>

    <xsl:template match="chapter/title">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>

    <xsl:template match="section">
        <section>
            <xsl:apply-templates select="@xml:id"/>
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="@xml:id">
        <xsl:attribute name="id" select="."/>
    </xsl:template>

    <xsl:template match="section[@role = 'footer']">
        <section>
            <footer>
                <xsl:apply-templates/>
            </footer>
        </section>
    </xsl:template>

    <xsl:template match="section[@role = 'footer']/title" priority="10"/>

    <xsl:template match="section[@role = 'footer']/para" priority="10"> <hr/> <xsl:apply-templates/>
        <br/>Registered address: <xsl:value-of
        select="/book/info/author/address/(* except otheraddr)" separator=", "/>
        <br/>Registration number: <xsl:value-of
        select="/book/info/author/address/otheraddr[@role = 'companyNumber']"/>
        <br/>VAT number: <xsl:value-of
        select="/book/info/author/address/otheraddr[@role = 'VATNumber']"/> </xsl:template>

    <xsl:template match="chapter/section/title">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <xsl:template match="section/section/title">
        <h3>
            <xsl:apply-templates/>
        </h3>
    </xsl:template>

    <xsl:template match="para">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="sidebar">
        <label for="{generate-id()}" class="margin-toggle">
            <xsl:value-of select="$margin-note-symbol"/>
        </label>
        <input type="checkbox" id="{generate-id()}" class="margin-toggle"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="sidebar/para">
        <span class="marginnote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="footnote">
        <label for="{generate-id()}" class="margin-toggle sidenote-number"/>
        <input type="checkbox" id="{generate-id()}" class="margin-toggle"/>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="footnote/para">
        <span class="sidenote">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="link[@xlink:href]">
        <a href="{@xlink:href}">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="date[@role = 'copyright']">
        <xsl:value-of select="year-from-date(current-date())"/>
    </xsl:template>

    <xsl:template match="itemizedlist">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="listitem">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="variablelist">
        <dl>
            <xsl:apply-templates/>
        </dl>
    </xsl:template>

    <xsl:template match="varlistentry/listitem">
        <dd>
            <xsl:apply-templates/>
        </dd>
    </xsl:template>

    <xsl:template match="varlistentry/term">
        <dt>
            <xsl:apply-templates/>
        </dt>
    </xsl:template>

    <xsl:template match="emphasis">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>

</xsl:stylesheet>
