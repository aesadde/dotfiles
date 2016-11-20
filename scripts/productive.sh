#!/usr/bin/env bash
#===============================================================================
#          FILE: productive.sh
#         USAGE: ./productive.sh
#
#   DESCRIPTION: rewrite some hosts rules to prevent going on social network
#
#       OPTIONS: -true prevent social networks -false procrastinate mode
#  REQUIREMENTS: bash
#          BUGS:
#         NOTES:
#        AUTHOR: Alberto Sadde
#       CREATED: 04/11/2015
#       VERSION: 0.1
#===============================================================================
case "$1" in
  -h)
    echo "-true for turning off social networks \n -false to go back to normal"
    ;;
  -true)
    sudo echo "
    ##
    # Host Database
    #
    # localhost is used to configure the loopback interface
    # when the system is booting.  Do not change this entry.
    ##
    127.0.0.1	localhost
    255.255.255.255	broadcasthost
    ::1             localhost
    # BEGIN SELFCONTROL BLOCK
    0.0.0.0	pocket.com
    ::	pocket.com
    0.0.0.0	9gag.com
    ::	9gag.com
    0.0.0.0	facebook.com
    ::	facebook.com
    0.0.0.0	news.google.com
    ::	news.google.com
    0.0.0.0	vine.co
    ::	vine.co
    0.0.0.0	pinterest.com
    ::	pinterest.com
    0.0.0.0	funnyordie.com
    ::	funnyordie.com
    0.0.0.0	forbes.com
    ::	forbes.com
    0.0.0.0	bbc.co.uk
    ::	bbc.co.uk
    0.0.0.0	telegraph.co.uk
    ::	telegraph.co.uk
    0.0.0.0	gawker.com
    ::	gawker.com
    0.0.0.0	jezebel.com
    ::	jezebel.com
    0.0.0.0	vice.com
    ::	vice.com
    0.0.0.0	huffingtonpost.com
    ::	huffingtonpost.com
    0.0.0.0	gothamist.com
    ::	gothamist.com
    0.0.0.0	theonion.com
    ::	theonion.com
    0.0.0.0	tumblr.com
    ::	tumblr.com
    0.0.0.0	usatoday.com
    ::	usatoday.com
    0.0.0.0	wsj.com
    ::	wsj.com
    0.0.0.0	washingtonpost.com
    ::	washingtonpost.com
    0.0.0.0	theguardian.com
    ::	theguardian.com
    0.0.0.0	nydailynews.com
    ::	nydailynews.com
    0.0.0.0	salon.com
    ::	salon.com
    0.0.0.0	msnbc.com
    ::	msnbc.com
    0.0.0.0	rt.com
    ::	rt.com
    0.0.0.0	aol.com
    ::	aol.com
    0.0.0.0	nypost.com
    ::	nypost.com
    0.0.0.0	bloomberg.com
    ::	bloomberg.com
    0.0.0.0	nationalgeographic.com
    ::	nationalgeographic.com
    0.0.0.0	chicagotribune.com
    ::	chicagotribune.com
    0.0.0.0	latimes.com
    ::	latimes.com
    0.0.0.0	www.news.google.com
    ::	www.news.google.com
    0.0.0.0	usnews.com
    ::	usnews.com
    0.0.0.0	www.9gag.com
    ::	www.9gag.com
    0.0.0.0	drudgereport.com
    ::	drudgereport.com
    0.0.0.0	msn.com
    ::	msn.com
    0.0.0.0	www.pocket.com
    ::	www.pocket.com
    0.0.0.0	news.yahoo.com
    ::	news.yahoo.com
    0.0.0.0	www.vine.co
    ::	www.vine.co
    0.0.0.0	stumbleupon.com
    ::	stumbleupon.com
    0.0.0.0	cnn.com
    ::	cnn.com
    0.0.0.0	bbc.com
    ::	bbc.com
    0.0.0.0	foxnews.com
    ::	foxnews.com
    0.0.0.0	dailymotion.com
    ::	dailymotion.com
    0.0.0.0	www.vice.com
    ::	www.vice.com
    0.0.0.0	hulu.com
    ::	hulu.com
    0.0.0.0	www.gothamist.com
    ::	www.gothamist.com
    0.0.0.0	twitter.com
    ::	twitter.com
    0.0.0.0	nytimes.com
    ::	nytimes.com
    0.0.0.0	buzzfeed.com
    ::	buzzfeed.com
    0.0.0.0	collegehumor.com
    ::	collegehumor.com
    0.0.0.0	netflix.com
    ::	netflix.com
    0.0.0.0	www.forbes.com
    ::	www.forbes.com
    0.0.0.0	www.tumblr.com
    ::	www.tumblr.com
    0.0.0.0	www.telegraph.co.uk
    ::	www.telegraph.co.uk
    0.0.0.0	www.nypost.com
    ::	www.nypost.com
    0.0.0.0	www.usatoday.com
    ::	www.usatoday.com
    0.0.0.0	www.rt.com
    ::	www.rt.com
    0.0.0.0	www.msnbc.com
    ::	www.msnbc.com
    0.0.0.0	www.bloomberg.com
    ::	www.bloomberg.com
    0.0.0.0	www.bbc.co.uk
    ::	www.bbc.co.uk
    0.0.0.0	www.drudgereport.com
    ::	www.drudgereport.com
    0.0.0.0	www.nationalgeographic.com
    ::	www.nationalgeographic.com
    0.0.0.0	www.facebook.com
    ::	www.facebook.com
    0.0.0.0	www.latimes.com
    ::	www.latimes.com
    0.0.0.0	www.chicagotribune.com
    ::	www.chicagotribune.com
    0.0.0.0	www.jezebel.com
    ::	www.jezebel.com
    0.0.0.0	www.gawker.com
    ::	www.gawker.com
    0.0.0.0	www.pinterest.com
    ::	www.pinterest.com
    0.0.0.0	www.funnyordie.com
    ::	www.funnyordie.com
    0.0.0.0	www.stumbleupon.com
    ::	www.stumbleupon.com
    0.0.0.0	www.twitter.com
    ::	www.twitter.com
    0.0.0.0	www.washingtonpost.com
    ::	www.washingtonpost.com
    0.0.0.0	www.wsj.com
    ::	www.wsj.com
    0.0.0.0	www.huffingtonpost.com
    ::	www.huffingtonpost.com
    0.0.0.0	www.dailymotion.com
    ::	www.dailymotion.com
    0.0.0.0	www.theonion.com
    ::	www.theonion.com
    0.0.0.0	api.twitter.com
    ::	api.twitter.com
    0.0.0.0	www.collegehumor.com
    ::	www.collegehumor.com
    0.0.0.0	www.theguardian.com
    ::	www.theguardian.com
    0.0.0.0	www.salon.com
    ::	www.salon.com
    0.0.0.0	www.nydailynews.com
    ::	www.nydailynews.com
    0.0.0.0	www.cnn.com
    ::	www.cnn.com
    0.0.0.0	www.foxnews.com
    ::	www.foxnews.com
    0.0.0.0	www.aol.com
    ::	www.aol.com
    0.0.0.0	www.usnews.com
    ::	www.usnews.com
    0.0.0.0	www.msn.com
    ::	www.msn.com
    0.0.0.0	www.hulu.com
    ::	www.hulu.com
    0.0.0.0	www.nytimes.com
    ::	www.nytimes.com
    0.0.0.0	www.news.yahoo.com
    ::	www.news.yahoo.com
    0.0.0.0	www.bbc.com
    ::	www.bbc.com
    0.0.0.0	www.buzzfeed.com
    ::	www.buzzfeed.com
    0.0.0.0	www.netflix.com
    ::	www.netflix.com
    0.0.0.0	www.web.whatsapp.com
    ::	www.web.whatsapp.com
    # END SELFCONTROL BLOCK
    " > /etc/hosts
    osascript -l JavaScript -e "Application('Firefox').quit(); Application('Firefox').activate()"
    ;;
  -false)
    sudo  echo "
    ##
    # Host Database
    #
    # localhost is used to configure the loopback interface
    # when the system is booting.  Do not change this entry.
    ##
    127.0.0.1	localhost
    255.255.255.255	broadcasthost
    ::1             localhost
    ;;
    " > /etc/hosts
esac
