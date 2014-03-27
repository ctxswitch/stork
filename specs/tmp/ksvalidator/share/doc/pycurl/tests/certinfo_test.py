#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vi:ts=4:et

import pycurl
import unittest
import nose.plugins.skip

from . import appmanager
from . import util

setup_module, teardown_module = appmanager.setup(('app', 8383, dict(ssl=True)))

class CertinfoTest(unittest.TestCase):
    def setUp(self):
        self.curl = pycurl.Curl()
    
    def tearDown(self):
        self.curl.close()
    
    # CURLOPT_CERTINFO was introduced in libcurl-7.19.1
    @util.min_libcurl(7, 19, 1)
    def test_certinfo_option(self):
        assert hasattr(pycurl, 'OPT_CERTINFO')
    
    # CURLOPT_CERTINFO was introduced in libcurl-7.19.1
    @util.min_libcurl(7, 19, 1)
    @util.only_ssl
    def test_request_without_certinfo(self):
        self.curl.setopt(pycurl.URL, 'https://localhost:8383/success')
        sio = util.BytesIO()
        self.curl.setopt(pycurl.WRITEFUNCTION, sio.write)
        # self signed certificate
        self.curl.setopt(pycurl.SSL_VERIFYPEER, 0)
        self.curl.perform()
        assert sio.getvalue().decode() == 'success'
        
        certinfo = self.curl.getinfo(pycurl.INFO_CERTINFO)
        self.assertEqual([], certinfo)
    
    # CURLOPT_CERTINFO was introduced in libcurl-7.19.1
    @util.min_libcurl(7, 19, 1)
    @util.only_ssl
    def test_request_with_certinfo(self):
        # CURLOPT_CERTINFO only works with OpenSSL
        if 'openssl' not in pycurl.version.lower():
            raise nose.plugins.skip.SkipTest('libcurl does not use openssl')
        
        self.curl.setopt(pycurl.URL, 'https://localhost:8383/success')
        sio = util.BytesIO()
        self.curl.setopt(pycurl.WRITEFUNCTION, sio.write)
        self.curl.setopt(pycurl.OPT_CERTINFO, 1)
        # self signed certificate
        self.curl.setopt(pycurl.SSL_VERIFYPEER, 0)
        self.curl.perform()
        assert sio.getvalue().decode() == 'success'
        
        certinfo = self.curl.getinfo(pycurl.INFO_CERTINFO)
        # self signed certificate, one certificate in chain
        assert len(certinfo) == 1
        certinfo = certinfo[0]
        # convert to a dictionary
        certinfo_dict = {}
        for entry in certinfo:
            certinfo_dict[entry[0]] = entry[1]
        assert 'Subject' in certinfo_dict
        assert 'PycURL test suite' in certinfo_dict['Subject']
