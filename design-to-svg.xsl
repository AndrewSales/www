<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xs='http://www.w3.org/2001/XMLSchema'
    xmlns:ajs='http://www.andrewsales.com/xslt'
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:variable name="stitch-size" select="6"/>
    
    <xsl:attribute-set name="stroke">
        <xsl:attribute name="stroke-width" select="3"/>
        <xsl:attribute name="stroke-linecap" select="'round'"/>
    </xsl:attribute-set>
    
    <xsl:template match="design">
        <svg baseProfile="full" version="1.1">
            <xsl:apply-templates select="row" mode='lines'/>
        </svg>
    </xsl:template>
    
    <xsl:template match="row" mode="squares">
        <xsl:apply-templates select="col" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="col" mode="squares">
        <rect 
            width="{$stitch-size}" 
            height="{$stitch-size}" 
            x="{position() * $stitch-size}" 
            y='{count(preceding::row) * $stitch-size}'
            fill='{@colour}'/>
    </xsl:template>
    
    <xsl:template match="row" mode="lines">
        <xsl:comment>row <xsl:value-of select="position()"/></xsl:comment>
        <xsl:apply-templates select="col" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="col" mode="lines">
        <xsl:variable name="stroke" select='@colour'/>
        <!-- add one to give these some padding -->
        <xsl:variable name="x" select="count(preceding-sibling::col) + 1"/>
        <xsl:variable name="y" select="count(preceding::row) + 1"/>
        
        <!-- top left to bottom right -->
        <line 
            x1="{$x * $stitch-size}"
            x2="{($x + 1) * $stitch-size}"
            y1="{$y * $stitch-size}"
            y2="{($y + 1) * $stitch-size}"
            stroke='{$stroke}' 
            xsl:use-attribute-sets="stroke"/>
        
        <!-- top right to bottom left -->
        <line 
            x1="{($x + 1) * $stitch-size}"
            x2="{$x * $stitch-size}"
            y1="{$y * $stitch-size}"
            y2="{($y + 1) * $stitch-size}"
            stroke='{$stroke}'
            xsl:use-attribute-sets="stroke"/>
    </xsl:template>
    
    <xsl:template match="col[not(@colour)]" mode="#all"/>
        
    <xsl:function name="ajs:neighbour-colours-differ" as="xs:boolean">
        <xsl:param name="col" as='element(col)'/>
        
        <xsl:variable name="pos" select="count($col/preceding-sibling::col) + 1"/>
        <xsl:variable name="my-colour" select="$col/@colour" as="attribute(colour)?"/>
        <xsl:variable name="neighbour-colours" select="$col/../(preceding-sibling::row[1]/col[$pos] | following-sibling::row[1]/col[$pos])/@colour |
            $col/(preceding-sibling::col[1] | following-sibling::col[1])/@colour" as="attribute(colour)*"/>
        
        <xsl:sequence select="exists($my-colour) 
            and
            count($neighbour-colours) = 4
            "/>
    </xsl:function>
    
</xsl:stylesheet>