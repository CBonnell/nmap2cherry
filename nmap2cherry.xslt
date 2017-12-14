<?xml version="1.0"?>
<!--
Copyright (c) 2017 Corey Bonnell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-->

<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" />

    <xsl:template match="/">
        <cherrytree>
            <xsl:apply-templates select="/nmaprun" />
        </cherrytree>
    </xsl:template>
    
    <xsl:template match="nmaprun">
        <node prog_lang="custom-colors" name="Scan Result">
            <rich_text>
                <xsl:value-of select="concat('Arguments: ', @args, '&#xA;')" />
            </rich_text>
            <rich_text>
                <xsl:variable name="run-time">
                    <xsl:value-of select="@startstr"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="runstats/finished/@timestr"/>
                    <xsl:value-of select="concat(' (', runstats/finished/@elapsed, ' seconds)')" />
                </xsl:variable>
                <xsl:value-of select="concat('Run time: ', $run-time, '&#xA;')" />
            </rich_text>
            <rich_text>
                <xsl:value-of select="concat('Summary: ', runstats/finished/@summary)" />
            </rich_text>
            <xsl:apply-templates select="host[status/@state='up']" />
        </node>
    </xsl:template>

    <xsl:template match="host">
        <xsl:variable name="ip-addr" select="address[@addrtype='ipv4']/@addr" />

        <node prog_lang="custom-colors" name="{$ip-addr}">
            <rich_text>
                <xsl:value-of select="concat('MAC address: ', address[@addrtype='mac']/@addr, ' (', address[@addrtype='mac']/@vendor, ')&#xA;')" />
                <xsl:value-of select="concat('Up reason: ', status/@reason)" />
                <xsl:for-each select="hostnames/hostname">
                    <xsl:value-of select="concat('&#xA;Hostname: ', @name, ' (', @type, ')')" />
                </xsl:for-each>
            </rich_text>
            <xsl:apply-templates select="ports/port" />
            <xsl:apply-templates select="hostscript/script" />
        </node>
    </xsl:template>

    <xsl:template match="port">
        <xsl:if test="contains(state/@state, 'open')">
            <xsl:variable name="custom_icon_id">
                <xsl:choose>
                    <xsl:when test="contains(state/@state, 'filtered')">
                        <xsl:text>2</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <node prog_lang="custom-colors" custom_icon_id="{$custom_icon_id}" name="{concat(@portid, ' (', upper-case(@protocol), ')')}">
                <rich_text>
                    <xsl:value-of select="concat('State: ', state/@state, ' (', state/@reason, ')')" />
                </rich_text>
                <xsl:if test="service">
                    <rich_text>
                        <xsl:value-of select="concat('&#xA;Service name: ', service/@name, ' (', service/@method, ')')" />
                        <xsl:if test="service/@product">
                            <xsl:value-of select="concat('&#xA;Product: ', service/@product, ' ', service/@version)" />
                        </xsl:if>
                        <xsl:if test="service/@extrainfo">
                            <xsl:value-of select="concat('&#xA;Extra info: ', service/@extrainfo)" />
                        </xsl:if>
                        <xsl:if test="service/cpe">
                            <xsl:for-each select="service/cpe">
                                <xsl:value-of select="concat('&#xA;CPE: ', text())" />
                            </xsl:for-each>
                        </xsl:if>
                    </rich_text>
                </xsl:if>
                <xsl:apply-templates select="script" />
            </node>
        </xsl:if>
    </xsl:template>

    <xsl:template match="script">
        <node prog_lang="custom-colors" name="{@id}">
            <rich_text>
                <xsl:value-of select="@output" />
            </rich_text>
        </node>
    </xsl:template>
</xsl:stylesheet>
