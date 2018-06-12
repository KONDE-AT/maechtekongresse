<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei" version="2.0"><!-- <xsl:strip-space elements="*"/>-->
    <xsl:param name="document"/>
    <xsl:param name="app-name"/>
    <xsl:param name="collection-name"/>
    <xsl:param name="path2source"/>
    <xsl:param name="ref"/><!--
##################################
### Seitenlayout und -struktur ###
##################################
-->
    <xsl:template match="/">
        <div class="page-header">
            <h2 align="center">
                <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']">
                    <xsl:apply-templates/>
                    <br/>
                </xsl:for-each>
            </h2>
        </div>
        <div class="regest">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        <h2 align="center">Header/Metadaten</h2>
                    </h3>
                </div>
                <div class="panel-body">
                    <table class="table table-striped">
                        <tbody>
                            <tr>
                                <th>
                                    <abbr title="tei:titleStmt/tei:title">Titel</abbr>
                                </th>
                                <td>
                                    <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']">
                                        <xsl:apply-templates/>
                                        <br/>
                                    </xsl:for-each>
                                </td>
                            </tr>

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
                                            <xsl:text>· </xsl:text>
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
                            <tr>
                                <th>
                                    <abbr title="//tei:editor">Herausgeber</abbr>
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
                                        <abbr title="//tei:availability//tei:p[1]">License</abbr>
                                    </th>
                                    <xsl:choose>
                                        <xsl:when test="//tei:licence[@target]">
                                         <td align="center">
                                             <a class="navlink" target="_blank">
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
                            <xsl:for-each select="//tei:sourceDesc/tei:msDesc"><!-- Split -->
                                <xsl:variable name="msDivId" select="@xml:id"/>  
                                <xsl:variable name="divlink" select="concat('#',$msDivId)"/>
                                <tr style="background-color:#ccc;">
                                    <th>
                                        <abbr title="//tei:text/tei:body/tei:div[@decls]">Bezeichnung</abbr>
                                    </th>
                                    <td style="font-weight:bold;">
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$divlink"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="//tei:text/tei:body/tei:div[@decls = concat('#',$msDivId)]/*/string-join(tei:title//text()[not(ancestor::note)], '')"/>
                                        </a>
                                    </td>
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
                                            <br/>
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
                            </xsl:for-each>
                        </tbody>
                    </table>
                    <div class="panel-footer">
                        <p style="text-align:center;">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$path2source"/>
                                </xsl:attribute>
                                see the TEI source of this document
                            </a>
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <h2 align="center">
                        Body
                    </h2>
                </h3>
            </div>
            <div class="panel-body">
                <xsl:if test="//tei:div//tei:title">
                    <h3 id="clickme">
                        <abbr title="Click to display Table of Contents">[Table of Contents]</abbr>
                    </h3>
                    <div id="headings" class="readmore">
                        <ul>
                            <xsl:for-each select="/tei:TEI/tei:text/tei:body//tei:div//tei:title">
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
                                            <xsl:value-of select="."/>
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
            <div class="panel-footer">
                <p style="text-align:center;">
                    <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note">
                        <div class="footnotes">
                            <xsl:element name="a">
                                <xsl:attribute name="name">
                                    <xsl:text>fn</xsl:text>
                                    <xsl:number level="any" format="1" count="tei:note"/>
                                </xsl:attribute>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="1" count="tei:note"/>
                                    </xsl:attribute>
                                    <span style="font-size:7pt;vertical-align:super;">
                                        <xsl:number level="any" format="1" count="tei:note"/>
                                    </span>
                                </a>
                            </xsl:element>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </p>
            </div>
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
        <xsl:element name="h3">
            <xsl:attribute name="style">margin-top:3em;margin-bottom:1em</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:element name="hr"/>
    </xsl:template>
    <!--    footnotes -->
    <xsl:template match="tei:note">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <span style="font-size:7pt;vertical-align:super;">
                <xsl:number level="any" format="1" count="tei:note"/>
            </span>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:div">
        <xsl:variable name="msId" select="substring-after(@decls, '#')"/>
        <xsl:variable name="handId" select="substring-after(@hand, '#')"/>
        <xsl:choose>
            <xsl:when test="@decls">
                <xsl:element name="div">
                    <xsl:attribute name="id">
                        <xsl:value-of select="$msId"/>
                    </xsl:attribute>
                    <xsl:element name="p">
                        <xsl:text>Hand von </xsl:text>
                        <xsl:value-of select="root()//tei:handNote[@xml:id=$handId]"/>
                    </xsl:element>
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
            <xsl:when test="@target[ends-with(.,'.xml')]">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                       show.html?document=<xsl:value-of select="@target"/>
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
    
    <xsl:template match="tei:persName[@ref]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </strong>
    </xsl:template>
    <xsl:template match="tei:rs[@ref or @key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">listperson.xml</xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </strong>
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
        <xsl:element name="strong">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>[Bl. </xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
        <xsl:element name="hr"/>
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
        <h3>
            <div>
                <xsl:apply-templates/>
            </div>
        </h3>
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
</xsl:stylesheet>