<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:fc="http://www.fedora.info/definitions/1/0/types/"
    xmlns:functx="http://www.functx.com"
    exclude-result-prefixes="xs xd tei fc" version="2.0">

    <xsl:include href="http://www.xsltfunctions.com/xsl/functx-1.0-nodoc-2007-01.xsl"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="path" select="'file:///C:/Users/skurz/Documents/git/kongress/data/editions'"/>
    <xsl:variable name="texts" select="tokenize('Aachen_Dok_50.xml   Aachen_Prot_26.xml  Aachen_Prot_43.xml   Laibach_Prot_16.xml  Verona_I_11.xml  Verona_I_9.xml
        Aachen_Prot_1.xml   Aachen_Prot_27.xml  Aachen_Prot_44.xml   Laibach_Prot_2.xml   Verona_I_12.xml  Verona_II_1.xml
        Aachen_Prot_10.xml  Aachen_Prot_28.xml  Aachen_Prot_45.xml   Laibach_Prot_3.xml   Verona_I_13.xml  Verona_II_2.xml
        Aachen_Prot_11.xml  Aachen_Prot_29.xml  Aachen_Prot_46.xml   Laibach_Prot_4.xml   Verona_I_14.xml  Verona_II_3.xml
        Aachen_Prot_12.xml  Aachen_Prot_3.xml   Aachen_Prot_47.xml   Laibach_Prot_5.xml   Verona_I_15.xml  Verona_II_4.xml
        Aachen_Prot_13.xml  Aachen_Prot_30.xml  Aachen_Prot_48.xml   Laibach_Prot_6.xml   Verona_I_16.xml  Verona_II_5.xml
        Aachen_Prot_14.xml  Aachen_Prot_31.xml  Aachen_Prot_49.xml   Laibach_Prot_7.xml   Verona_I_17.xml  Verona_II_6.xml
        Aachen_Prot_15.xml  Aachen_Prot_32.xml  Aachen_Prot_5.xml    Laibach_Prot_8.xml   Verona_I_18.xml  Verona_II_7.xml
        Aachen_Prot_16.xml  Aachen_Prot_33.xml  Aachen_Prot_6.xml    Laibach_Prot_9.xml   Verona_I_19.xml  Verona_II_8.xml
        Aachen_Prot_17.xml  Aachen_Prot_34.xml  Aachen_Prot_7.xml    Troppau_Prot_1.xml   Verona_I_2.xml   Verona_III_1.xml
        Aachen_Prot_18.xml  Aachen_Prot_35.xml  Aachen_Prot_8.xml    Troppau_Prot_2.xml   Verona_I_20.xml  Verona_III_2.xml
        Aachen_Prot_19.xml  Aachen_Prot_36.xml  Aachen_Prot_9.xml    Troppau_Prot_3.xml   Verona_I_21.xml  Verona_III_3.xml
        Aachen_Prot_2.xml   Aachen_Prot_37.xml  Laibach_Prot_1.xml   Troppau_Prot_4.xml   Verona_I_22.xml  Verona_IX_1.xml
        Aachen_Prot_20.xml  Aachen_Prot_38.xml  Laibach_Prot_10.xml  Troppau_Prot_5.xml   Verona_I_3.xml   Verona_V_1.xml
        Aachen_Prot_21.xml  Aachen_Prot_39.xml  Laibach_Prot_11.xml  Troppau_Prot_6.xml   Verona_I_4.xml   Verona_V_2.xml
        Aachen_Prot_22.xml  Aachen_Prot_4.xml   Laibach_Prot_12.xml  Troppau_Prot_7.xml   Verona_I_5.xml   Verona_VI_1.xml
        Aachen_Prot_23.xml  Aachen_Prot_40.xml  Laibach_Prot_13.xml  Troppau_Prot_8.xml   Verona_I_6.xml   Verona_VII_1.xml
        Aachen_Prot_24.xml  Aachen_Prot_41.xml  Laibach_Prot_14.xml  Verona_I_1.xml       Verona_I_7.xml   Verona_VIII_1.xml
        Aachen_Prot_25.xml  Aachen_Prot_42.xml  Laibach_Prot_15.xml  Verona_I_10.xml      Verona_I_8.xml', '\s+')"/>



    <xsl:template match="/">
        <TEI>
            <xsl:call-template name="header"/>
            <xsl:call-template name="text"/>
        </TEI>
    </xsl:template>

    <xsl:template name="header">
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>Mächtekongresse eventSearch</title>
                </titleStmt>
                <publicationStmt>
                    <p>Publication Information</p>
                </publicationStmt>
                <sourceDesc>
                    <p>Generated from Mächtekongresse TEI files</p>
                </sourceDesc>
            </fileDesc>
        </teiHeader>
    </xsl:template>

    <xsl:template name="text">
        <text>
            <body>
                <xsl:for-each select="$texts">
                    <xsl:sort/>
                    <xsl:variable name="source" select="document(concat($path, '/', .))"/>
                    <xsl:variable name="url" select="concat($source//tei:TEI/@xml:base, '/', $source//tei:TEI/@xml:id)"/>
                    <xsl:variable name="pid" select="$source//tei:publicationStmt/tei:idno[1]"/>
                    <xsl:variable name="title" select="$source//tei:title[@type = 'main'][1]"/>
                    <listEvent type="generated">
                        <head>Events für „<xsl:value-of select="$title"/>“</head>
                        
                        <xsl:for-each
                            select="$source//tei:body/tei:div[1]">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="id" select="concat($pid, '_', position())"/>
                                <xsl:with-param name="url" select="$url" />
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </listEvent>
                </xsl:for-each>
            </body>
        </text>
    </xsl:template>
    
    <xsl:template match="tei:div[parent::tei:body][1]">
        <xsl:param name="id"/>
        <xsl:param name="url"/>
        <xsl:variable name="date">
            <xsl:choose>
                <xsl:when test="//tei:history[1]/tei:origin/tei:date">
                    <xsl:value-of select="//tei:history[1]/tei:origin[1]/tei:date[1]/@when[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="//tei:body//tei:opener[1]/tei:dateline[1]/tei:date[1]/@when"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="place">
            <xsl:value-of select="//tei:history[1]/tei:origin[1]/tei:placeName"/>
        </xsl:variable>

        <event type="protocol">
            <xsl:variable name="date" select="functx:substring-before-if-contains($date, ' ')"/>
            <xsl:variable name="place" select="functx:substring-before-if-contains($place, ' ')"/>
            <xsl:attribute name="when" select="$date"/>
            <xsl:attribute name="xml:id" select="$id"/>
            <xsl:attribute name="source" select="$url"/>
            <head>Mächtekongresse Sitzung am 
                <date>
                    <xsl:attribute name="when"><xsl:value-of select="$date"/></xsl:attribute>
                    <xsl:value-of select="$date"/>
                </date> in
                <placeName><xsl:value-of select="$place"/></placeName>
            </head>
            <label type="derived">
                <xsl:value-of select="//tei:profileDesc/tei:abstract"/>
            </label>
        </event>
    </xsl:template>
    

</xsl:stylesheet>
