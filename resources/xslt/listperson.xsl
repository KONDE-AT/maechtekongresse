<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base_index.xsl"/>
    <xsl:param name="entiyID"/>
    <xsl:variable name="entity" as="node()">
        <xsl:choose>
            <xsl:when test="//tei:person[@xml:id=$entiyID][1]">
                <xsl:value-of select="//tei:person[@xml:id=$entiyID][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">       
        <div class="modal" id="myModal" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content">
                    <xsl:choose>
                        <xsl:when test="$entity">
                            <xsl:variable name="entity" select="//tei:person[@xml:id=$entiyID]"/>
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span class="fa fa-times"/>
                                </button>
                                <h3 class="modal-title">
                                    <xsl:choose>
                                        <xsl:when test="//$entity//tei:surname[1]/text()">
                                            <xsl:value-of select="$entity//tei:surname[1]/text()"/>
                                            <xsl:if test="$entity//tei:forename[1]/text()">
                                                <xsl:text>, </xsl:text>
                                                <xsl:value-of select="$entity//tei:forename[1]/text()"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$entity//tei:persName[1]"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </h3>
                                <h4>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat('hits.html?searchkey=', $entiyID)"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        <xsl:attribute name="rel">noopener noreferrer</xsl:attribute>
                                        Klicken für alle Erwähnungen
                                    </a>
                                </h4>
                            </div>
                            <div class="modal-body">
                                <table class="table table-boardered table-hover">
                                    <xsl:for-each select="$entity//tei:persName">
                                        <tr>
                                            <th>
                                                Name
                                            </th>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="./tei:forename and ./tei:surname">
                                                        <xsl:value-of select="concat(./tei:forename, ' ', ./tei:surname)"/>
                                                    </xsl:when>
                                                    <xsl:when test="./tei:forename or ./tei:surname">
                                                        <xsl:value-of select="./tei:forename"/>
                                                        <xsl:value-of select="./tei:surname"/>
                                                    </xsl:when>
                                                </xsl:choose>                                                
                                            </td>
                                        </tr>
                                        <xsl:choose>
                                            <xsl:when test="$entity//tei:roleName">
                                                <tr>
                                                    <th>
                                                        Titel, Funktionen, Rollen
                                                    </th>
                                                    <td>
                                                        <xsl:for-each select="$entity//tei:roleName">
                                                            <xsl:value-of select="."/>
                                                            <br/>
                                                        </xsl:for-each>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                        </xsl:choose>
                                        <xsl:choose>
                                            <xsl:when test="$entity//tei:birth and $entity//tei:death">
                                                <tr>
                                                    <th>
                                                        Lebensdaten
                                                    </th>
                                                    <td>
                                                       <xsl:value-of select="$entity//tei:birth"/>–<xsl:value-of select="$entity//tei:death"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                            <xsl:when test="$entity//tei:birth">
                                                <tr>
                                                    <th>
                                                        *
                                                    </th>
                                                    <td>
                                                        <xsl:value-of select="$entity//tei:birth"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>
                                            <xsl:when test="$entity//tei:death">
                                                <tr>
                                                    <th>
                                                        ✝
                                                    </th>
                                                    <td>
                                                        <xsl:value-of select="$entity//tei:death"/>
                                                    </td>
                                                </tr>
                                            </xsl:when>

                                        </xsl:choose>
                                    </xsl:for-each>
                                    <xsl:if test="$entity//tei:idno[@type='URI']">
                                        <tr>
                                            <th>URL:</th>
                                            <td>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="$entity/tei:idno[@type='URI']/text()"/>
                                                    </xsl:attribute>
                                                    <xsl:value-of select="$entity/tei:idno[@type='URI']/text()"/>
                                                </a>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="$entity//tei:note">
                                        <tr>
                                            <td colspan="2">
                                                <xsl:value-of select="$entity//tei:note"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </table>
                                <div>
                                    <h4 data-toggle="collapse" data-target="#more"> mehr (TEI Datenstruktur)</h4>
                                    <div id="more" class="collapse">
                                        <xsl:choose>
                                            <xsl:when test="//*[@xml:id=$entiyID or @id=$entiyID]">
                                                <xsl:apply-templates select="//*[@xml:id=$entiyID or @id=$entiyID]" mode="start"/>
                                            </xsl:when>
                                            <xsl:otherwise>Kein Registereintrag für ID<strong>
                                                <xsl:value-of select="concat(' ', $entiyID)"/>
                                            </strong> 
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </div>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span class="fa fa-times"/>
                                </button>
                                <h3 class="modal-title">
                                    Kein Registereintrag <strong>
                                        <xsl:value-of select="$entiyID"/>
                                    </strong> für die gesuchte ID  
                                </h3>
                                
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
            $(window).load(function(){
            $('#myModal').modal('show');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>