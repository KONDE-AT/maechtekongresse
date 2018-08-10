<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:import href="shared/base_index.xsl"/>
    <xsl:param name="entiyID"/>
    <xsl:variable name="entity" as="node()">
        <xsl:choose>
            <xsl:when test="not(empty(//tei:bibl[@xml:id = $entiyID][1]))">
                <xsl:value-of select="//tei:bibl[@xml:id = $entiyID][1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:if test="$entity">
            <div class="modal" id="myModal" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <xsl:choose>
                            <xsl:when test="$entity">
                                <xsl:variable name="entity" select="//tei:bibl[@xml:id = $entiyID]"/>
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal">
                                        <span class="fa fa-times"/>
                                    </button>
                                    <h3 class="modal-title">
                                        <xsl:value-of select="$entity/text()"/>  </h3>
                                    <h4>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('hits.html?searchkey=', $entiyID)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            <xsl:attribute name="rel">noopener noreferrer</xsl:attribute>
                                            Klicken für alle Erwähnungen </a>
                                    </h4>
                                </div>
                                <div class="modal-body">
                                    <table class="table table-boardered table-hover">
                                        <xsl:if test="$entity/tei:idno[@type = 'URI']">
                                            <tr>
                                                <th>URL:</th>
                                                <td>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of select="$entity/tei:idno[@type = 'URI']/text()"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="$entity/tei:idno[@type = 'URI']/text()"/>
                                                  </a>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="$entity/tei:idno[not(@type='URI')]">
                                            <tr>
                                                <th>URL:</th>
                                                <td>
                                                  <xsl:value-of select="$entity/tei:idno/text()"/>
                                                </td>
                                            </tr>
                                        </xsl:if>
                                    </table>
                                    <div>
                                        <h4 data-toggle="collapse" data-target="#more"> mehr (TEI
                                            Datenstruktur)</h4>
                                        <div id="more" class="collapse">
                                            <xsl:choose>
                                                <xsl:when test="//*[contains(@xml:id, $entiyID) or contains(@id, $entiyID)]">
                                                  <xsl:apply-templates select="//*[contains(@xml:id, $entiyID) or contains(@id, $entiyID)]" mode="start"/>
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
                        </xsl:choose>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Schließen</button>
                        </div>
                    </div>
                </div>
            </div>
        </xsl:if>
        <script type="text/javascript">
            $(window).load(function(){
            $('#myModal').modal('show');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>