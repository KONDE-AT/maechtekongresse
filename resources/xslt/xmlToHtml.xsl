<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:import href="shared/base.xsl"/>
    <xsl:output indent="no"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="prev-doc-name"/>
    <xsl:param name="ref"/>
    <xsl:variable name="prev-doc-path" select="if ($ref != '' and $prev-doc-name != '') then replace($xmlFullPath, $ref, $prev-doc-name) else ()"/>
    <xsl:param name="next-doc-name"/>
    <xsl:variable name="next-doc-path" select="if ($ref != '' and $next-doc-name != '') then replace($xmlFullPath, $ref, $next-doc-name) else ()"/>
    <xsl:param name="xmlFullPath"/>
    <xsl:variable name="prev-doc" select="if ($prev-doc-name != '' and doc-available($prev-doc-path)) then doc($prev-doc-path) else ()"/>
    <xsl:variable name="next-doc" select="if ($next-doc-name != '' and doc-available($next-doc-path)) then doc($next-doc-path) else ()"/>
    <xsl:variable name="prev-doc-title" select="$prev-doc//tei:title[@type='main'][1]"/>
    <xsl:variable name="next-doc-title" select="$next-doc//tei:title[@type='main'][1]"/>
    
    <xsl:strip-space elements="*"/>
    <!--<xsl:strip-space elements="note ref rs abbr persName author add hi choice expan orgName tei:note tei:ref tei:rs tei:abbr tei:persName tei:author tei:add tei:hi tei:choice tei:expan tei:orgName"/>-->
    <xsl:preserve-space elements="tei:persName tei:roleName tei:surname"/>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <nav class="navbar" id="ph">
                <xsl:if test="$prev-doc-name != ''">
                <ul class="nav navbar-nav pager nav-pills">
                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('show.html?document=', $prev-doc-name)"/>
                        </xsl:attribute> 
                        <xsl:attribute name="class">btn btnPrev</xsl:attribute>
                        <xsl:attribute name="title">
                                <xsl:value-of select="$prev-doc-title"/>
                            </xsl:attribute>
                        Vorheriges<br/>Dokument
                    </a>
                </li>
                </ul>
                </xsl:if>
                <xsl:if test="$next-doc-name != ''">
                <ul class="nav navbar-nav pager nav-pills navbar-right">
                    <li>
                    <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('show.html?document=', $next-doc-name)"/>
                            </xsl:attribute> 
                            <xsl:attribute name="class">btn btnNext</xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="$next-doc-title"/>
                            </xsl:attribute>
                        Nächstes<br/>Dokument
                    </a>
                </li>
                </ul>
                </xsl:if>
            </nav>
            <h2 style="text-align:center">
                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']">
                    <xsl:apply-templates/>
                    <xsl:if test="position() != last()">
                        <br/>
                    </xsl:if>
                </xsl:for-each>
            </h2>
        </div>
        <div class="regest">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title" align="center">
                        Header/Metadaten
                    </h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <tbody>
                            <xsl:if test="//tei:abstract">
                                <tr>
                                    <th>
                                        <abbr title="//tei:abstract">Regest</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:abstract"/>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="//tei:particDesc/tei:listPerson/tei:person">
                                <tr>
                                    <th>
                                        <abbr title="//tei:particDesc/tei:listPerson/tei:person">Anwesende</abbr>
                                    </th>
                                    <td>
                                        <xsl:for-each select="//tei:particDesc/tei:listPerson/tei:person">
                                            <xsl:apply-templates/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> · </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="//tei:supportDesc/tei:extent">
                                <tr>
                                    <th>
                                        <abbr title="//tei:supportDesc/tei:extent">Extent</abbr>
                                    </th>
                                    <td>
                                        <xsl:apply-templates select="//tei:supportDesc/tei:extent"/>
                                    </td>
                                </tr>
                            </xsl:if>
                        </tbody>
                    </table>
                    <div class="panel-footer">
                        <p style="text-align:center;">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$path2source"/>
                                </xsl:attribute>
                                TEI Quelldaten anzeigen
                            </a>
                        </p>
                        <p style="text-align:center;">
                            <a data-toggle="collapse" data-target="#metadata" title="Klicken für Zeigen/Verbergen">vollständige Header/Metadaten anzeigen</a>
                        </p>
                    </div>
                    </div>
                <div class="panel-body collapse" id="metadata">
                        <xsl:for-each select="//tei:sourceDesc/tei:msDesc"><!-- Split -->
                            <xsl:variable name="msDivId" select="@xml:id"/>  
                            <xsl:variable name="divlink" select="concat('#',$msDivId)"/>
                            <div class="well">
                            <div class="panel-body">
                                <xsl:attribute name="id">m<xsl:value-of select="$msDivId"/>
                                </xsl:attribute>
                                
                                <table class="table table-striped">
                                    <tbody>
                                        <tr style="background-color:#ccc;">
                                            <xsl:choose>
                                                <xsl:when test="//tei:text/tei:body/tei:div[@decls]/*/tei:title">
                                            <th>
                                                <abbr title="//tei:text/tei:body/tei:div[@decls]/*/tei:title">Bezeichnung</abbr>
                                            </th>
                                            <td style="font-weight:bold;">
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$divlink"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="//tei:text/tei:body/tei:div[@decls = concat('#',$msDivId)]/*/string-join(tei:title//text()[not(ancestor-or-self::tei:note)], '')"/>
                                                </a>
                                            </td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <th>
                                                        <abbr title="//msDesc/msContents/msItem">Bezeichnung</abbr>
                                                    </th>
                                                    <td style="font-weight:bold;">
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="$divlink"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="root()//msDesc[@xml:id = concat('#',$msDivId)]/msContents/msItem/*/string-join(tei:title//text()[not(ancestor-or-self::tei:note)], '')"/>
                                                        </a>
                                                    </td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </tr>
                                        <xsl:if test="./@type">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:msDesc/@type">Dokumentenart</abbr>
                                                </th>
                                                <td>
                                                    <xsl:value-of select="./@type"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <tr>
                                            <th>
                                                <abbr title="//tei:history/tei:origin">Ort/Datum</abbr>
                                            </th>
                                            <td>
                                                <xsl:value-of select=".//tei:history/tei:origin/tei:placeName"/>
                                                <xsl:if test="not(.//tei:history/tei:origin/tei:placeName)">
                                                    <xsl:text>o.O.</xsl:text>
                                                </xsl:if>
                                                <xsl:text>, </xsl:text>
                                                <xsl:value-of select="format-date(xs:date(.//tei:history/tei:origin/tei:date[1]/@when), '[D]. [M02]. [Y0001]')"/>
                                                <xsl:if test="not(.//tei:history/tei:origin/tei:date/@when)">
                                                    <xsl:text>o.D.</xsl:text>
                                                </xsl:if>
                                            </td>
                                        </tr>
                                        <xsl:if test=".//tei:msIdentifier">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:msIdentifier">Signatur</abbr>
                                                </th>
                                                <td>
                                                    <xsl:for-each select=".//tei:msIdentifier/child::*">
                                                        <abbr>
                                                            <xsl:attribute name="title">
                                                                <xsl:value-of select="name()"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="."/>
                                                        </abbr>
                                                        <xsl:if test="position() != last()">, </xsl:if>
                                                    </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test=".//tei:msContents">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:msContents">Stückbeschreibung</abbr>
                                                </th>
                                                <td>
                                                    <xsl:apply-templates select=".//tei:msContents"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test=".//tei:physDesc">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:physDesc">Materialbeschreibung <br/>
                                                        Hände
                                                    </abbr>
                                                </th>
                                                <td>
                                                    <xsl:apply-templates select=".//tei:physDesc"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="..//tei:listWit[@corresp=$divlink]/tei:witness">
                                            <xsl:for-each select="root()//tei:listWit[@corresp=$divlink]/tei:witness/@corresp">
                                                <xsl:variable name="witId" select="substring-after(., '#')"/>
                                                <tr>
                                                    <th>
                                                        <abbr> 
                                                            <xsl:attribute name="title">//tei:listWit <xsl:value-of select="$witId"/>
                                                            </xsl:attribute>
                                                            vgl. gedruckte Quelle</abbr>
                                                    </th>
                                                    <td>
                                                        <xsl:for-each select="root()//tei:listWit/tei:witness[@xml:id=$witId]">
                                                            <a>
                                                                <xsl:attribute name="href">../pages/bibl.html#myTable=f<xsl:value-of select="$witId"/>
                                                                </xsl:attribute>
                                                                <xsl:apply-templates select="root()//tei:listWit/tei:witness[@xml:id=$witId]"/>
                                                            </a>
                                                            <xsl:value-of select="normalize-space(substring-after(root()//tei:listWit[@corresp=$divlink]/tei:witness[@corresp=concat('#', $witId)], 'S.'))"/>
                                                        </xsl:for-each>
                                                    </td>
                                                </tr>
                                            </xsl:for-each>
                                        </xsl:if>  
                                    </tbody>
                                </table>
                            </div>
                            </div>
                        </xsl:for-each>
                    
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title" align="center">
                    Text
                </h3>
            </div>
            <div class="panel panel-body">
                <xsl:if test="//tei:div//tei:title">
                    <h3 id="clickme">
                        <abbr title="Für Abschnitte klicken">[Abschnitte]</abbr>
                    </h3>
                    <div id="headings" class="readmore">
                        <ul>
                            <xsl:for-each select="/tei:TEI/tei:text/tei:body//tei:div//tei:title[not(@type = ('sub', 'desc'))]">
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:text>#hd</xsl:text>
                                            <xsl:number level="any"/>
                                        </xsl:attribute>
                                        <xsl:number level="multiple" count="tei:div" format="1.1. "/>
                                    </a>
                                    <xsl:choose>
                                        <xsl:when test=".//tei:orig">
                                            <xsl:apply-templates select=".//tei:orig"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="string-join(.//text()[not(ancestor-or-self::tei:note or ancestor-or-self::tei:expan)], '')"/>
<!--                                            <xsl:apply-templates select=".//*[not(self::tei:note)]"/>-->
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                </xsl:if>

                <div>
                    <xsl:apply-templates select="//tei:text"/>
                </div>
            </div>
            <xsl:if test="tei:TEI/tei:text/tei:body//tei:note">
            <div class="panel-footer">
                <h4 title="mit Buchstaben gezählte Noten sind im Originaldokument vorhanden, alle anderen stammen von der Herausgeberin">Anmerkungen</h4>
                <p>
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='author']">
                        <div class="footnotes">
                            <xsl:element name="a">
                                <xsl:attribute name="name">
                                    <xsl:text>fn</xsl:text>
                                    <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
                                </xsl:attribute>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
                                    </xsl:attribute>
                                    <span style="font-size:7pt;vertical-align:super;">
                                        <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
                                    </span>
                                </a>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='editorial']">
                        <div class="footnotes">
                            <xsl:element name="a">
                                <xsl:attribute name="name">
                                    <xsl:text>fn</xsl:text>
                                    <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
                                </xsl:attribute>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
                                    </xsl:attribute>
                                    <span style="font-size:7pt;vertical-align:super;">
                                        <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
                                    </span>
                                </a>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </p>
            </div>
            </xsl:if>
        </div>     
            <div class="panel panel-default">
                <table class="table table-striped">
                    <tbody>
                        <tr>
                            <th>
                                <abbr title="//tei:editor">Herausgeberin</abbr>
                            </th>
                            <td>
                                <xsl:for-each select="//tei:author">
                                    <xsl:apply-templates/>
                                </xsl:for-each>
                                <xsl:if test="//tei:titleStmt/tei:editor">
                                    <xsl:for-each select="//tei:titleStmt/tei:editor">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                    <xsl:text>, </xsl:text>
                                    <xsl:for-each select="//tei:publicationStmt/tei:publisher">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                    <xsl:text>, </xsl:text>
                                    <xsl:for-each select="//tei:publicationStmt/tei:pubPlace">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                </xsl:if>    
                            </td>
                        </tr>
                <xsl:if test="//tei:titleStmt/tei:respStmt">
                    <tr>
                        <th>
                            <abbr title="//tei:titleStmt/tei:respStmt">responsible</abbr>
                        </th>
                        <td>
                            <xsl:for-each select="//tei:titleStmt/tei:respStmt">
                                <p>
                                    <xsl:apply-templates/>
                                </p>
                            </xsl:for-each>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <th>
                        <abbr title="//tei:availability//tei:p[1]">Lizenz</abbr>
                    </th>
                    <xsl:choose>
                        <xsl:when test="//tei:licence[@target]">
                            <td>
                                <a class="navlink" target="_blank" rel="noopener noreferrer">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="//tei:licence[1]/data(@target)"/>
                                </a>
                            </td>
                        </xsl:when>
                        <xsl:when test="//tei:licence">
                            <td>
                                <xsl:apply-templates select="//tei:licence"/>
                            </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td>no license provided</td>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
                </tbody>
                </table>
<!--            </div>-->
            <script type="text/javascript">
                $(document).ready(function(){
                $( "div[class~='readmore']" ).hide();
                });
                $("#clickme").click(function(){
                $( "div[class~='readmore']" ).toggle("slow");
                });
            </script>
        </div>
    </xsl:template><!--
    #####################
    ###  Formatierung ###
    #####################
-->
    
    <xsl:template match="tei:term">
        <span/>
    </xsl:template>
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='ul'">
                <u>
                    <xsl:apply-templates/>
                </u>
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:otherwise><!-- style durchreichen -->
                <span>
                    <xsl:choose>
                        <xsl:when test="@rend">
                            <xsl:variable name="style" select="substring-after(@rend, '#')"/>
                            <xsl:attribute name="style">
                                <xsl:value-of select="root()//tei:rend[@xml:id=current()/$style]"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:when test="@rendition">
                            <xsl:variable name="style" select="substring-after(@rendition, '#')"/>
                            <xsl:attribute name="style">
                                <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Div Titles (Beilagen/andere Dokumente) -->
    <xsl:template match="tei:p/tei:title">
        <xsl:element name="hr"/>
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
            <xsl:number level="any"/>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="h3">
            <xsl:attribute name="style">margin-top:3em;margin-bottom:1em</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note[@type='editorial']">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="1" count="tei:note[@type='editorial']"/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:note[@type='author']">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="a" count="tei:note[@type='author']"/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:variable name="msId" select="substring-after(@decls, '#')"/>
        <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
        <xsl:choose>
            <xsl:when test="@decls">
                <xsl:element name="div">
                    <xsl:attribute name="class">well</xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="$msId"/>
                    </xsl:attribute>
                    <xsl:if test="root()//tei:handNote[@xml:id=$handId]">
                        <xsl:element name="p">
                            <xsl:attribute name="title">//tei:handNote</xsl:attribute>
                            <em>
                            <xsl:text>Hand: </xsl:text>
                            <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                        </em>
                        </xsl:element>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@type='regest'">
                <div>
                    <xsl:attribute name="class">
                        <text>regest</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when><!-- transcript -->
            <xsl:when test="@type='transcript'">
                <div>
                    <xsl:attribute name="class">
                        <text>transcript</text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </div>
            </xsl:when><!-- Anlagen/Beilagen  -->
            <xsl:when test="@xml:id">
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template><!-- Verweise auf andere Dokumente   -->
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="@target[contains(.,'.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                       show.html?document=<xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@decls[contains(.,'#m.')]">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@decls"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template><!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/> 
    </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:physDesc/tei:handDesc/tei:handNote">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template>
    <!-- reference strings   --> <!-- generic, referring to persons, places, witnesses etc. -->
    <xsl:template match="tei:witness[@corresp]">
        <xsl:element name="strong">
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listwit.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@corresp), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>    
    <xsl:template match="tei:persName[@ref]">
        <xsl:element name="strong">
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <!--<tei:persName xml:space="preserve"><tei:forename>bla</tei:forename> <tei:surname>blo</tei:surname></tei:persName>-->
    <!--<xsl:template match="tei:persName/*">
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::*">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>-->
    <xsl:template match="tei:orgName[@ref]">
        <xsl:element name="strong">
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listorg.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
<!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>color:blue;</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@place='margin'">
                        <xsl:text>zeitgenössische Ergänzung am Rand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='above'">
                        <xsl:text>zeitgenössische Ergänzung oberhalb </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='below'">
                        <xsl:text>zeitgenössische Ergänzung unterhalb </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='inline'">
                        <xsl:text>zeitgenössische Ergänzung in der gleichen Zeile </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='top'">
                        <xsl:text>zeitgenössische Ergänzung am oberen Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='bottom'">
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@hand">
                    <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
                    <xsl:text>durch </xsl:text>
                    <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                    <xsl:text> (</xsl:text>
                        <xsl:value-of select="./@hand"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:text/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- app/rdg tooltip testing -->
    <xsl:template match="tei:app">
        <xsl:variable name="handId" select="substring-after(tei:rdg/tei:add/@hand, '#')"/>
            <xsl:apply-templates select="./tei:lem"/>
            <xsl:element name="a">
                <xsl:attribute name="style">font-size:7pt;vertical-align:super;</xsl:attribute>
                <xsl:attribute name="class">shortRdg</xsl:attribute>
                <xsl:attribute name="href">#</xsl:attribute>
                <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="data-placement">top</xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], '] ', normalize-space(.)),' ')"/>
                </xsl:attribute>
                <xsl:text>[Variante]</xsl:text>
            </xsl:element>
            <xsl:element name="span">
                <xsl:attribute name="class">fullRdg</xsl:attribute>
                <xsl:attribute name="style">display:none</xsl:attribute>
                <xsl:value-of select="concat(tokenize(./tei:lem,' ')[1], ' … ', tokenize(./tei:lem,' ')[last()]), string-join(tei:rdg/concat(tei:add/@hand, '] ', normalize-space(.)),' ')"/>
            </xsl:element>
    </xsl:template>
    <!-- damage supplied -->
    <xsl:template match="tei:damage">
        <xsl:element name="span">
            <xsl:attribute name="style">color:blue</xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="@agent"/>
            </xsl:attribute>
            <xsl:text> […]</xsl:text>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="style">color:blue</xsl:attribute>
            <xsl:attribute name="title">editorische Ergänzung</xsl:attribute>
            <xsl:text>‹</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>›</xsl:text>
        </xsl:element>
    </xsl:template>
    <!-- choice -->
    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="tei:sic and tei:corr">
                <span class="alternate choice4" title="alternate">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates select="tei:corr[1]"/>
                    <span class="hidden altcontent ">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id" select="@xml:id"/>
                        </xsl:if>
                        <xsl:apply-templates select="tei:sic[1]"/>
                    </span>
                </span>
            </xsl:when>
            <xsl:when test="tei:abbr and tei:expan">
                <abbr>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:attribute name="title">
                        <xsl:value-of select="tei:expan"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="tei:abbr[1]"/>
                    <span class="hidden altcontent ">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id" select="@xml:id"/>
                        </xsl:if>
                        <xsl:apply-templates select="tei:expan[1]"/>
                    </span>
                </abbr>
            </xsl:when>
            <xsl:when test="tei:orig and tei:reg">
                <span class="alternate choice6" title="alternate">
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates select="tei:reg[1]"/>
                    <span class="hidden altcontent ">
                        <xsl:if test="@xml:id">
                            <xsl:attribute name="id" select="@xml:id"/>
                        </xsl:if>
                        <xsl:apply-templates select="tei:orig[1]"/>
                    </span>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- Bücher -->
    <xsl:template match="tei:bibl">
        <xsl:element name="span">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <xsl:element name="hr"/>
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>[Bl. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template><!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:if test="not(string(number(.))='NaN')">
                <xsl:attribute name="style">text-align:right</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Überschriften -->
    <xsl:template match="tei:title">
        <xsl:if test="@xml:id[starts-with(.,'org') or starts-with(.,'ue')]">
            <a>
                <xsl:attribute name="name">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
                <xsl:text> </xsl:text>
            </a>
        </xsl:if>
        <a>
            <xsl:attribute name="name">
                <xsl:text>hd</xsl:text>
                <xsl:number level="any"/>
            </xsl:attribute>
            <xsl:text> </xsl:text>
        </a>
        <xsl:choose>
            <xsl:when test="@type='sub' or 'desc'">
                <h4>
                    <xsl:apply-templates/>
                </h4>
            </xsl:when>
            <xsl:otherwise>
                <h3>
                    <div>
                        <xsl:apply-templates/>
                    </div>
                </h3>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template><!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template><!-- Absätze    -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:signed/tei:list/tei:item">
        <xsl:element name="p">
            <xsl:attribute name="style">
                <xsl:text>text-align:right; margin-right:3em</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:back"/><!-- ignoring complete back, whose include references were adjusted for avoiding oXygen complaining -->
<!-- The generic approach of handing down durchreichen rendition attributes is resulting in numerous errors. To be implemented differently. -->
<!--    <xsl:template match="//*[@rend] | //*[@rendition]">
    <span>
        <xsl:choose>
            <xsl:when test="@rend">
                <xsl:variable name="style" select="substring-after(@rend, '#')"/>
                <xsl:attribute name="style">
                    <xsl:value-of select="root()//tei:rend[@xml:id=current()/$style]"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@rendition">
                <xsl:variable name="style" select="substring-after(@rendition, '#')"/>
                <xsl:attribute name="style">
                    <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </span>
</xsl:template>-->
</xsl:stylesheet>