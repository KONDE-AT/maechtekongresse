<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://test.org/" xmlns:config="http://www.digital-archiv.at/ns/kongress/config" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base.xsl"/>
    <xsl:output indent="no"/>
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="app-title"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="base-url"/>
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
    <xsl:preserve-space elements="p tei:p tei:title tei:persName tei:roleName tei:surname tei:rs"/>
    <!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <xsl:comment>base-url: <xsl:value-of select="$base-url"/>
            </xsl:comment>
                <xsl:if test="$prev-doc-name != ''">
                <ul class="pager nav-pills phl">
                <li>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="concat('show.html?document=', $prev-doc-name)"/>
                        </xsl:attribute> 
                        <xsl:attribute name="class">previous</xsl:attribute>
                        <xsl:attribute name="title">
                                <xsl:value-of select="$prev-doc-title"/>
                            </xsl:attribute>
                        Vorheriges<br/>Dokument
                    </a>
                </li>
                </ul>
                </xsl:if>
                <xsl:if test="$next-doc-name != ''">
                <ul class="pager nav-pills phr">
                    <li>
                    <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('show.html?document=', $next-doc-name)"/>
                            </xsl:attribute> 
                            <xsl:attribute name="class">next</xsl:attribute>
                            <xsl:attribute name="title">
                                <xsl:value-of select="$next-doc-title"/>
                            </xsl:attribute>
                        Nächstes<br/>Dokument
                    </a>
                </li>
                </ul>
                </xsl:if>
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
                                <xsl:choose>
                                    <xsl:when test="count(//tei:abstract) &gt; 1">
                                        <xsl:for-each select="//tei:abstract">
                                            <xsl:variable name="x">
                                                <xsl:number level="any" count="tei:abstract"/>
                                            </xsl:variable>
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:abstract">Regest
                                                        <xsl:text> Nr. </xsl:text>
                                                            <xsl:value-of select="$x"/>
                                                    </abbr>
                                                </th>
                                                <td>
                                                    <em>
                                                        <xsl:apply-templates select="//tei:abstract[position()=$x]"/>
                                                    </em>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tr>
                                            <th>
                                                <abbr title="//tei:abstract">Regest</abbr>
                                            </th>
                                            <td>
                                                <em>
                                                    <xsl:apply-templates select="//tei:abstract"/>
                                                </em>
                                            </td>
                                        </tr>
                                    </xsl:otherwise>
                                </xsl:choose>
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
                        <div class="pull-right">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$path2source"/>
                                </xsl:attribute>
                                <xsl:attribute name="title">TEI Quelldaten anzeigen</xsl:attribute>
                                TEI
                            </a>
                        </div>
                        <p style="text-align:center;">
                            <a data-toggle="collapse" data-target="#metadata" title="Klicken für Zeigen/Verbergen">Mehr Dokumentinformationen anzeigen</a>
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
                                                <xsl:if test=".//tei:msContents">
                                                    <tr style="background-color:#ccc;font-weight:bold;">
                                                        <th>
                                                            <abbr title="//tei:msContents">Bezeichnung</abbr>
                                                        </th>
                                                        <td>
                                                            <a>
                                                                <xsl:attribute name="href">
                                                                    <xsl:value-of select="$divlink"/>
                                                                </xsl:attribute>
                                                                <xsl:apply-templates select=".//tei:msContents"/>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </xsl:if>
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
                                                        <xsl:choose>
                                                            <xsl:when test="tei:idno">
                                                                <xsl:for-each select="./tei:idno">
                                                                    <xsl:value-of select="."/>
                                                                    <xsl:if test="position() != last()">, </xsl:if>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <abbr>
                                                                    <xsl:attribute name="title">
                                                                        <xsl:value-of select="name()"/>
                                                                    </xsl:attribute>
                                                                    <xsl:value-of select="."/>
                                                                </abbr>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="position() != last()">, </xsl:if>
                                                    </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test=".//tei:physDesc">
                                            <tr>
                                                <th>
                                                    <abbr title="//tei:physDesc">Stückbeschreibung 
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
                                                            Vgl. gedruckte Quelle</abbr>
                                                    </th>
                                                    <td>
                                                        <xsl:for-each select="../tei:bibl">
                                                            <a>
                                                                <xsl:attribute name="href">../pages/bibl.html#myTable=f<xsl:value-of select="$witId"/>
                                                                </xsl:attribute>
                                                                <xsl:value-of select="."/>
                                                            </a>
                                                        </xsl:for-each>
                                                    </td>
<!--                                                    <td>
                                                        <xsl:for-each select="root()//tei:listWit/tei:witness[@xml:id=$witId]">
                                                            <a>
                                                                <xsl:attribute name="href">../pages/bibl.html#myTable=f<xsl:value-of select="$witId"/>
                                                                </xsl:attribute>
                                                                <xsl:apply-templates select="root()//tei:listWit/tei:witness[@xml:id=$witId]/tei:bibl"/>
                                                            </a>
                                                            <xsl:text> S. </xsl:text>
                                                            <xsl:value-of select="normalize-space(substring-after(root()//tei:listWit[@corresp=$divlink]/tei:witness[@corresp=concat('#', $witId)], 'S.'))"/>
                                                        </xsl:for-each>
                                                    </td>-->
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
                <xsl:if test="count(//tei:div) &gt; 1">
                    <h3 id="clickme">
                        <abbr title="Für Abschnitte klicken" style="color:#23527c">Abschnitte</abbr>
                    </h3>
                    <div id="headings" class="readmore">
                        <ul>
                            <xsl:for-each select="/tei:TEI/tei:text/tei:body//tei:div">
                                <xsl:variable name="msIdlink" select="@decls"/>
                                <xsl:variable name="msId" select="substring-after($msIdlink,'#')"/>
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$msIdlink"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="root()//tei:msDesc[@xml:id=$msId]//tei:title"/>
                                    </a>
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
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='author']">
                        <div class="footnote">
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
                    <xsl:if test="tei:TEI/tei:text/tei:body//tei:note[@type='author']">
                        <br/>
                    </xsl:if>
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note[@type='editorial']">
                        <div class="footnote">
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
                
                <xsl:if test="tei:TEI/tei:text/tei:body//tei:app">
                    <h4 title="Zur Überlieferung der Varianten siehe auch die Metadaten oben" data-toggle="collapse" data-target="#metadata" href="#metadata">Varianten</h4>
                <p>
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:app">
                        <xsl:variable name="handId" select="substring-after(./tei:rdg//@hand, '#')"/>
                        <div class="footnotes">
                            <xsl:element name="a">
                                <xsl:attribute name="name">
                                    <xsl:text>fn</xsl:text>
                                    <xsl:number level="any" format="i" count="tei:app"/>
                                </xsl:attribute>
                                    <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="i" count="tei:app"/>
                                    </xsl:attribute>
                                    <span style="font-size:7pt;vertical-align:super;">
                                        <xsl:number level="any" format="i" count="tei:app"/>
                                    </span>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:if test="$handId">
                                <xsl:text>Hand von </xsl:text>
                                <xsl:element name="span">
                                    <xsl:attribute name="title">//handNote: <xsl:value-of select="$handId"/>
                                            </xsl:attribute>
                                    <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                                </xsl:element>
                                <xsl:text>: </xsl:text>
                            </xsl:if>
                            <xsl:apply-templates select="child::*[not(self::tei:lem)]"/>
                        </div>
                    </xsl:for-each>
                </p>
                    </xsl:if>
            </div>
            </xsl:if>
        </div>     
            <div class="panel panel-default">
                <table class="table table-striped">
                    <tbody>
                        <tr>
                            <th>
                                <abbr title="Zitierhilfe">Zitierempfehlung</abbr>
                            </th>
                            <td>
                                <xsl:value-of select="//tei:titleStmt//tei:title[@type='main']"/>. In:
                                <xsl:value-of select="$app-title"/>
                                <xsl:if test="//tei:titleStmt/tei:editor">
                                    <xsl:text>, hrsg. von </xsl:text>
                                    <xsl:for-each select="//tei:titleStmt/tei:editor[not(@role)]">
                                        <xsl:value-of select="./tei:persName/tei:forename"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="./tei:persName/tei:surname"/>
                                    </xsl:for-each>
                                    <xsl:if test="//tei:titleStmt/tei:editor[@role]">
                                        <xsl:text> unter Mitarbeit von </xsl:text>
                                        <xsl:for-each select="//tei:titleStmt/tei:editor[@role]">
                                            <span>
                                                <xsl:attribute name="title">
                                                    <xsl:value-of select="./tei:persName/@ref"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="./tei:persName/tei:forename"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="./tei:persName/tei:surname"/>
                                            </span>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:text>, </xsl:text>
                                    <xsl:for-each select="//tei:publicationStmt/tei:pubPlace">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                    <xsl:text>: </xsl:text>
                                    <xsl:for-each select="//tei:publicationStmt/tei:publisher">
                                        <xsl:apply-templates/>
                                    </xsl:for-each>
                                </xsl:if>    
                                <xsl:text> 2018. URL: https://</xsl:text>
                                <xsl:value-of select="substring-before($base-url,', ')"/>
                                <xsl:text>/pages/show.html?document=</xsl:text>
                                <xsl:value-of select="substring-after(string($xmlFullPath),'editions/')"/>
                                <xsl:text>&amp;directory=</xsl:text>
                            <xsl:value-of select="$collection-name"/>
                                <xsl:text>, abgerufen </xsl:text>
                                <xsl:value-of select="format-date(current-date(), '[D01].[M01].[Y0001]')"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="format-time(current-time(), '[H01]:[m01]') "/>
                                <xsl:text>.</xsl:text>
                            </td>
                        </tr>
                <xsl:if test="//tei:titleStmt/tei:respStmt">
                    <tr>
                        <th>
                            <abbr title="//tei:titleStmt/tei:respStmt">Verantwortlichkeiten</abbr>
                        </th>
                        <td>
                                <ul>
                                <xsl:for-each select="//tei:titleStmt/tei:respStmt/tei:resp">
                                <li>
                                    <xsl:if test="@role">
                                        <xsl:value-of select="@role"/>
                                        <xsl:text>: </xsl:text> 
                                    </xsl:if> 
                                    <xsl:value-of select="."/>
                                            <xsl:text>: </xsl:text>
                                    <xsl:for-each select="following-sibling::tei:name">
                                        <xsl:value-of select="."/>
                                        <xsl:if test="position() != last()">, </xsl:if>
                                    </xsl:for-each>
                                    <!--<xsl:apply-templates/>-->
                                </li>
                                </xsl:for-each>
                                </ul>
                            <xsl:for-each select="//tei:notesStmt/tei:note">
                                <p>
                                    <xsl:apply-templates select="."/>
<!--                                    <xsl:apply-templates/>-->
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
    <xsl:template match="tei:msItem">
        <xsl:value-of select="."/>
    </xsl:template>
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
                            <xsl:attribute name="style">
                                <xsl:for-each select=".[contains(concat(' ', normalize-space(@rend), ' '), ' #')]">
                                    <xsl:variable name="style" select="substring-after(., '#')"/>
                                    <xsl:value-of select="root()//tei:rend[@xml:id=current()/$style]"/>
                                </xsl:for-each>
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>
                        <!--<xsl:when test="@rendition[contains(.,' ')]">
<!-\-                            <xsl:variable name="style" select="substring-after(@rendition, '#')"/>-\->
                            <xsl:variable name="x" select="tokenize(replace(data(@rendition), '#', ' '), ' ')" as="node()*"/>
                            <xsl:attribute name="style">
                                <xsl:for-each select="$x">
<!-\-                                    <xsl:variable name="style" select="substring-after(., '#')"/>-\->
                                    <xsl:variable name="style" select="concat('#',$x)"/>
<!-\-                                    <xsl:value-of select="concat('#',$style)"/>-\->
                                    <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                                </xsl:for-each>
<!-\-                                <xsl:value-of select="root()//tei:rendition[@xml:id=current()/$style]"/>
                                <xsl:value-of select="string-join(tokenize(replace(data(@rendition), '#', ''), ' '), '____')"/>
                                -\->
                            </xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:when>-->
                        <xsl:when test="@rendition[not(contains(.,' '))]">
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
<!--        <xsl:element name="hr"/>-->
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
    <xsl:template match="tei:handDesc">
        <xsl:text>Hände in diesem Dokument: </xsl:text>
        <xsl:for-each select="./tei:handNote">
            <span>
                <xsl:apply-templates/>
            </span>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <!-- reference strings   --> <!-- generic, referring to persons, places, witnesses etc. -->
    <xsl:template match="tei:witness[@corresp]">
        <xsl:element name="span">
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
        <xsl:element name="span">
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
        <xsl:element name="span">
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
    <xsl:template match="tei:opener">
        <xsl:element name="div">
            <xsl:attribute name="class">opener</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:dateline">
        <xsl:element name="p">
            <xsl:attribute name="class">ed</xsl:attribute>
            <xsl:attribute name="style">text-align:right;</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
<!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="class">
                <xsl:text>ergaenzt</xsl:text>
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
                        <xsl:text>zeitgenössische Ergänzung</xsl:text>
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
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
        </xsl:element>
    </xsl:template><!-- app/rdg tooltip testing -->
    <xsl:template match="tei:app">
        <xsl:variable name="handId" select="substring-after(tei:rdg/tei:add/@hand, '#')"/>
            <xsl:element name="span">
                <xsl:attribute name="class">shortRdg</xsl:attribute>
                <xsl:attribute name="href">#</xsl:attribute>
                <xsl:attribute name="data-toggle">tooltip</xsl:attribute>
                <xsl:attribute name="data-placement">top</xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], '] ', normalize-space(.)),' ')"/>
                </xsl:attribute>
                <xsl:attribute name="data-original-title">
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], '] ', normalize-space(.)),' ')"/>
                </xsl:attribute>
                <xsl:apply-templates select="./tei:lem"/>
            </xsl:element>
            <xsl:element name="a">
                <xsl:attribute name="name">
                    <xsl:text>fna_</xsl:text>
                    <xsl:number level="any" format="i" count="tei:app"/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#fn</xsl:text>
                    <xsl:number level="any" format="i" count="tei:app"/>
                </xsl:attribute>
                <xsl:attribute name="title">
                    <xsl:value-of select="string-join(tei:rdg/concat(root()//tei:handNote[@xml:id=$handId], ' ', normalize-space(.)),' ')"/>
                </xsl:attribute>
                <span style="font-size:7pt;vertical-align:super;" class="shortRdg">
                    <xsl:text>[Variante </xsl:text>
                    <xsl:number level="any" format="i" count="tei:app"/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:element>
            <xsl:element name="span">
                <xsl:attribute name="class">fullRdg</xsl:attribute>
                <xsl:attribute name="style">display:none</xsl:attribute>
                <xsl:value-of select="concat(tokenize(./tei:lem,' ')[1], ' … ', tokenize(./tei:lem,' ')[last()]), string-join(tei:rdg/concat(tei:add/@hand, '] ', normalize-space(.)),' ')"/>
            </xsl:element>
    </xsl:template>
    <xsl:template match="tei:lem">
        <xsl:apply-templates/>
    </xsl:template>
    <!-- damage supplied -->
    <xsl:template match="tei:damage">
        <xsl:element name="span">
            <xsl:attribute name="title">
                <xsl:value-of select="@agent"/>
            </xsl:attribute>
            <xsl:if test="not(following::tei:supplied or descendant::tei:supplied)">
                <xsl:text> […]</xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:element name="span">
            <xsl:attribute name="title">editorische Ergänzung
                <xsl:if test="parent::tei:damage">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="parent::tei:damage/@agent"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <xsl:text>&lt;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>&gt;</xsl:text>
        </xsl:element>
    </xsl:template>
    <!-- choice -->
    <xsl:template match="tei:sic">
        <xsl:apply-templates/>
        <xsl:element name="span">
            <xsl:attribute name="title">Fehler/Unstimmigkeit im Originaldokument, KS</xsl:attribute>
            <xsl:text> [sic]</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="tei:sic and tei:corr">
                <span class="alternate choice4">
                    <xsl:attribute name="title">Korrektur der Hrsg. aus: „<xsl:value-of select="tei:sic[1]"/>“</xsl:attribute>
                    <xsl:if test="@xml:id">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates select="tei:corr[1]"/>
                    <span class="hidden altcontent">
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
        <xsl:choose>        
            <xsl:when test="ancestor::tei:table">
                <xsl:variable name="colno" select="count(ancestor::tei:table/tei:row[1]/tei:cell)"/>
                <xsl:element name="tr">
                    <xsl:element name="td">
                        <xsl:attribute name="style">text-align:right;font-size:12px;</xsl:attribute>
                        <xsl:attribute name="colspan">
                            <xsl:value-of select="$colno"/>
                        </xsl:attribute>
                    <xsl:text>[Bl. </xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="class">
                    <xsl:text>hr</xsl:text>
                    </xsl:attribute>
                    <xsl:text>[Bl. </xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>]</xsl:text>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>    
    </xsl:template><!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="@rend='rules' and not(parent::tei:signed)">
                        <xsl:text>table table-bordered table-condensed table-hover</xsl:text>
                    </xsl:when>
                    <xsl:when test="parent::tei:signed">
                        <xsl:text>table table-borderless</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>table table-striped table-condensed table-hover</xsl:text>                        
                    </xsl:otherwise>
                </xsl:choose>
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
            <xsl:if test="./@rendition='#u'">
                <xsl:attribute name="style">border-bottom: 1px solid black</xsl:attribute>
                <xsl:attribute name="class">underline</xsl:attribute>
            </xsl:if>
            <xsl:if test="./@cols">
                <xsl:attribute name="colspan">
                    <xsl:value-of select="./@cols"/>
                </xsl:attribute>
                <xsl:if test="number(@cols) gt 2">
                    <xsl:attribute name="style">text-align:center</xsl:attribute>
                </xsl:if>
            </xsl:if>
            <xsl:if test="./@rows">
                <xsl:attribute name="rowspan">
                    <xsl:value-of select="./@rows"/>
                </xsl:attribute>
                <xsl:attribute name="style">vertical-align:middle</xsl:attribute>
            </xsl:if>
            <xsl:if test="not(string(number(.))='NaN') or .='-'">
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
                <h5>
                    <div>
                        <xsl:apply-templates/>
                    </div>
                </h5>
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
            <xsl:if test="ancestor::tei:text">
                <xsl:attribute name="class">ed</xsl:attribute>
            </xsl:if>
            <xsl:if test="./@rendition='#r'">
                <xsl:attribute name="style">
                    <xsl:text>text-align:right; margin-right:3rem;</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Substitutions -->
    <xsl:template match="tei:subst">
        <xsl:apply-templates/>
    </xsl:template><!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:function name="my:fetch-delSpan" as="element(tei:delSpan)?">
    <xsl:param name="n" as="node()"/>
    <!-- del will be the most recent delSpan milestone -->
    <xsl:variable name="del" select="$n/preceding::tei:delSpan[1]"/>
    <!-- $del/id(@spanTo) will be its end anchor -->
    <!-- return $del if its end anchor appears after the argument node -->
    <xsl:sequence select="$del[id(@spanTo) &gt;&gt; $n]"/>
    </xsl:function> 
    <xsl:template match="text()[exists(my:fetch-delSpan(.))]">
        <span class="deleted" style="text-decoration:line-through;">
            <xsl:next-match/>
        </span>
    </xsl:template> 
    <xsl:template match="tei:country">
        <span>
<!--            <xsl:attribute name="style">color:purple</xsl:attribute>-->
            <xsl:attribute name="title">//country</xsl:attribute>
                <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:label">
        <xsl:element name="p">
            <xsl:attribute name="class">ed</xsl:attribute>
            <xsl:attribute name="style">margin-left:-1em</xsl:attribute>
            <xsl:attribute name="title">Marginalie</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:g">
        <xsl:variable name="glyphId" select="@ref"/>
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:graphic/@url"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:desc"/>
            </xsl:attribute>
            <xsl:attribute name="style">width:4em;margin-left:3em;</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:glyph">
        <xsl:variable name="glyphId" select="@ref"/>
        <xsl:element name="img">
            <xsl:attribute name="src">
                <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:graphic/@url"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="root()//tei:charDecl/tei:glyph[$glyphId]/tei:desc"/>
            </xsl:attribute>
            <xsl:attribute name="style">width:4em;margin-left:3em;</xsl:attribute>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:element name="span">
            <xsl:attribute name="title">unsichere Lesung</xsl:attribute>
            <xsl:apply-templates/>
            <xsl:text> [?] </xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:gap">
        <xsl:element name="span">
            <xsl:attribute name="title">Textlücke</xsl:attribute>
            <xsl:attribute name="style">font-size:x-small;vertical-align:super;</xsl:attribute>
            <xsl:text> [Lücke</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>] </xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//tei:notesStmt/tei:note">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:signed">
        <xsl:choose>
            <xsl:when test="./tei:list">
            <xsl:for-each select="./tei:list/tei:item">
            <xsl:element name="p">
            <xsl:attribute name="class">
                <xsl:text>signed</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".">
                    <xsl:element name="p">
                        <xsl:attribute name="class">
                            <xsl:text>signed</xsl:text>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </xsl:element>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template><!-- attempting to match spaces around guillemets -->
<!--    <xsl:template match="//text()[matches(.,'« ')]">
        <xsl:text>« </xsl:text>
    </xsl:template>
    <xsl:template match="//text()[matches(.,' »')]">
        <xsl:text> »</xsl:text>
    </xsl:template>-->
    <xsl:template match="tei:back"/><!-- ignoring complete back, whose include references were adjusted for avoiding oXygen complaining -->
<!-- The generic approach of handing down durchreichen rendition attributes is resulting in numerous errors. To be implemented differently. -->
<!--<xsl:template match="//*[not(self::tei:cell) and @rendition]">
    <span>
        <xsl:choose>
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