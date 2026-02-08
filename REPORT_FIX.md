# 修复报告（无 Docker）

## 0. 基线信息（按要求原始输出）

### tree -L 3（或 ls -R）
```
.
├── PATCHES
│   ├── REPORT.md.20260208_095915.bak
│   ├── REPORT.md.20260208_095928.bak
│   ├── REPORT.md.20260208_100426.bak
│   ├── REPORT.md.20260208_100707.bak
│   └── REPORT.md.bak
├── README.md
├── REPORT.md
├── REPORT_FIX.md
├── admin-frontend
│   ├── ADMIN_FRONTEND_SUMMARY.md
│   ├── AGENTS.md
│   ├── API接口问题修复说明.md
│   ├── JavaScript变量重复声明问题修复.md
│   ├── README.md
│   ├── admin.log
│   ├── api-test.html
│   ├── css
│   │   ├── common.css
│   │   ├── components.css
│   │   └── layout.css
│   ├── dashboard.html
│   ├── js
│   │   ├── api.js
│   │   ├── common.js
│   │   └── components.js
│   ├── layout.html
│   ├── login.html
│   ├── nul
│   ├── pages
│   │   ├── adoptions.html
│   │   ├── cat-tags.html
│   │   ├── cats.html
│   │   ├── crowdfunding.html
│   │   ├── dashboard.html
│   │   ├── dynamics.html
│   │   ├── finance.html
│   │   ├── notifications.html
│   │   ├── rescues.html
│   │   ├── universities.html
│   │   ├── users.html
│   │   └── verifications.html
│   ├── server.js
│   ├── 修复完成总结.md
│   ├── 启动管理后台.bat
│   ├── 快速测试指南.md
│   ├── 新版管理后台说明.md
│   └── 管理员端完整检查报告.md
├── backend
│   ├── AGENTS.md
│   ├── BOOT-INF
│   │   └── classes
│   ├── META-INF
│   │   ├── MANIFEST.MF
│   │   └── maven
│   ├── application-override.yml
│   ├── application-prod.yml
│   ├── backend.log
│   ├── cat-rescue.jar
│   ├── logs
│   │   ├── cat-rescue.log
│   │   ├── cat-rescue.log.2026-02-01.0.gz
│   │   └── startup.log
│   ├── nul
│   ├── static
│   │   ├── assets
│   │   ├── images
│   │   ├── index.html
│   │   ├── serve.json
│   │   ├── server.js
│   │   └── uploads
│   └── 启动后端.bat
├── cat_rescue.sql
├── docker-compose.yml
├── frontend
│   ├── AGENTS.md
│   ├── api-test.html
│   ├── assets
│   │   ├── 404--baNMUlS.js
│   │   ├── 404-28Mlw5Os.js
│   │   ├── 404-29olXP9x.js
│   │   ├── 404-B0iprH5z.js
│   │   ├── 404-B2n-1NWe.js
│   │   ├── 404-Bo_eTBf_.js
│   │   ├── 404-CDlHsYuM.js
│   │   ├── 404-CGrDasB-.js
│   │   ├── 404-CITq5gO-.js
│   │   ├── 404-CQCnUwQv.js
│   │   ├── 404-D3l_9LhU.js
│   │   ├── 404-Do6UDUI3.js
│   │   ├── 404-T_LEGpPK.css
│   │   ├── _plugin-vue_export-helper-DlAUqK2U.js
│   │   ├── adoption-CMWGZ8Ww.js
│   │   ├── adoption-CiY7VzMz.js
│   │   ├── adoption-CjP0C-fO.js
│   │   ├── adoption-CxJZ4nw3.js
│   │   ├── adoption-DG_GffzV.js
│   │   ├── adoption-DVMSQmPI.js
│   │   ├── adoption-DdVNeMZk.js
│   │   ├── adoption-VkjgPlRC.js
│   │   ├── adoption-cHGKrDi-.js
│   │   ├── adoption-eug5KJCB.js
│   │   ├── adoption-fmvwDVLD.js
│   │   ├── adoption-uR_ohCBk.js
│   │   ├── adoptions-B2Ar8u13.js
│   │   ├── adoptions-BK8o7ncW.js
│   │   ├── adoptions-BNXFBnOx.js
│   │   ├── adoptions-Bl7LKSlO.js
│   │   ├── adoptions-CCncOHcP.js
│   │   ├── adoptions-CUbw4jRp.js
│   │   ├── adoptions-CnL_chET.js
│   │   ├── adoptions-DFPNDAaK.css
│   │   ├── adoptions-DbUG_Ilj.js
│   │   ├── adoptions-DmLimPwx.js
│   │   ├── adoptions-_WIBGWTC.js
│   │   ├── adoptions-c1sAb4v_.js
│   │   ├── adoptions-v6DF-5hz.js
│   │   ├── apply-BJeWAkYF.js
│   │   ├── apply-BTVSbSHy.js
│   │   ├── apply-BizmStjH.js
│   │   ├── apply-C1Y9WrOs.js
│   │   ├── apply-C328kp1R.js
│   │   ├── apply-CjXI-SBt.js
│   │   ├── apply-CqBuf6Cq.js
│   │   ├── apply-D1n7VuAI.js
│   │   ├── apply-DJ7BEJQn.css
│   │   ├── apply-DR2ULVyp.js
│   │   ├── apply-DZbMRvGC.js
│   │   ├── apply-PfjI0gcI.js
│   │   ├── apply-hrpZb84r.js
│   │   ├── cat-B1hHPUXx.js
│   │   ├── cat-B7UR_3So.js
│   │   ├── cat-BFi__BXU.js
│   │   ├── cat-BNSW1wqJ.js
│   │   ├── cat-Bh7QlOGh.js
│   │   ├── cat-Ck7rnad3.js
│   │   ├── cat-CmcS0UDJ.js
│   │   ├── cat-CxkuW-o2.js
│   │   ├── cat-DHVeo7bt.js
│   │   ├── cat-DT66Z2d1.js
│   │   ├── cat-DwVSNbqL.js
│   │   ├── cat-YjEz8_D4.js
│   │   ├── cat-tags-BD3tPIGQ.js
│   │   ├── cat-tags-COUY-BoZ.js
│   │   ├── cat-tags-CVAf_4lH.js
│   │   ├── cat-tags-CZEd4LAn.js
│   │   ├── cat-tags-Ci4cWEOp.js
│   │   ├── cat-tags-Cq_Nh0_F.js
│   │   ├── cat-tags-D1jAf0kg.js
│   │   ├── cat-tags-D3pu3em3.js
│   │   ├── cat-tags-DQDD5ybe.css
│   │   ├── cat-tags-Da_X5MKY.js
│   │   ├── cat-tags-OChO5vZv.js
│   │   ├── cat-tags-byrru6iy.js
│   │   ├── cats-B7ug0IAm.js
│   │   ├── cats-BvOrxlM-.css
│   │   ├── cats-C92_l_L1.js
│   │   ├── cats-CE03TWrb.js
│   │   ├── cats-COBABHLQ.js
│   │   ├── cats-COjVII7D.js
│   │   ├── cats-CQmQgqAO.js
│   │   ├── cats-CxUDCHuS.js
│   │   ├── cats-DGhpBXvO.js
│   │   ├── cats-Dp30FkeR.js
│   │   ├── cats-G_zNqHDp.js
│   │   ├── cats-K8hA_Wl8.js
│   │   ├── cats-Sl-taccJ.js
│   │   ├── community-AqAIWdcB.js
│   │   ├── community-B9PPt_GH.js
│   │   ├── community-BNkHmhbM.js
│   │   ├── community-Chh_JOHn.js
│   │   ├── community-CkBhywlv.js
│   │   ├── community-Czd4e_PL.js
│   │   ├── community-D3wOGpoH.js
│   │   ├── community-DB-126D4.js
│   │   ├── community-DIVrjsWr.js
│   │   ├── community-EhrKXgFR.js
│   │   ├── community-hPewukwB.js
│   │   ├── community-zI1o8fiI.js
│   │   ├── crowdfunding-BbC-EY3B.js
│   │   ├── crowdfunding-BfOaLfyL.js
│   │   ├── crowdfunding-BnJ3bsQL.js
│   │   ├── crowdfunding-Bq_0aBTd.css
│   │   ├── crowdfunding-BztTT10r.js
│   │   ├── crowdfunding-C7Tq9LI8.js
│   │   ├── crowdfunding-C7xfDids.js
│   │   ├── crowdfunding-CAahl_bE.js
│   │   ├── crowdfunding-CAk8lJtl.js
│   │   ├── crowdfunding-CEbXX_i7.js
│   │   ├── crowdfunding-DQ1Rz1o1.js
│   │   ├── crowdfunding-Ks94AgKf.js
│   │   ├── dashboard-BRdmK3-r.js
│   │   ├── dashboard-BRkRmsoc.js
│   │   ├── dashboard-Bxq2GEJ1.js
│   │   ├── dashboard-CAMYKrR6.js
│   │   ├── dashboard-CRMn0OQD.js
│   │   ├── dashboard-CV6rzKMC.js
│   │   ├── dashboard-CoIMV5Sy.js
│   │   ├── dashboard-D1W_5jYh.js
│   │   ├── dashboard-DEix7J6E.js
│   │   ├── dashboard-DMchsrLp.js
│   │   ├── dashboard-DbSFDXCu.js
│   │   ├── dashboard-QPfUC7xC.js
│   │   ├── dashboard-UdtMDklg.css
│   │   ├── dashboard-w5ZDsruu.css
│   │   ├── detail-B-JmCFZv.js
│   │   ├── detail-B2rO7qG_.js
│   │   ├── detail-B5yRa4cO.js
│   │   ├── detail-BHAg7W6v.js
│   │   ├── detail-BHEIAJLZ.js
│   │   ├── detail-BIjFMtQL.js
│   │   ├── detail-BM_Tf6rX.js
│   │   ├── detail-BONGwW6F.js
│   │   ├── detail-BcViFKY5.js
│   │   ├── detail-BdiZMMhP.js
│   │   ├── detail-BdrMZ6ov.js
│   │   ├── detail-BeSi0n3G.css
│   │   ├── detail-BueL_yDK.js
│   │   ├── detail-BwCBXfFc.css
│   │   ├── detail-C4bBd7MQ.js
│   │   ├── detail-C8cWWBjS.js
│   │   ├── detail-CGZvQFGH.js
│   │   ├── detail-CT2INzAE.js
│   │   ├── detail-CZqsWh9I.js
│   │   ├── detail-Cds9H7jr.js
│   │   ├── detail-CeIF31zc.js
│   │   ├── detail-CjDezn49.js
│   │   ├── detail-CkUIU0wt.js
│   │   ├── detail-ClGIz3nW.js
│   │   ├── detail-Co6uFV4P.css
│   │   ├── detail-CpW-ZxkK.js
│   │   ├── detail-D0Akfe3L.js
│   │   ├── detail-D2ri_hqS.js
│   │   ├── detail-DKJwJnlR.js
│   │   ├── detail-DVG2_N6_.js
│   │   ├── detail-DXggUf0p.js
│   │   ├── detail-DaNH3U2e.js
│   │   ├── detail-DaOK-l0D.js
│   │   ├── detail-DewfCn5n.js
│   │   ├── detail-Dl4bEloo.js
│   │   ├── detail-DzUEP37k.js
│   │   ├── detail-F7jovjbi.js
│   │   ├── detail-OUkH1qyB.js
│   │   ├── detail-R_1LPNGQ.css
│   │   ├── detail-iK8iFcDl.css
│   │   ├── detail-vj1h-xmu.js
│   │   ├── dynamics-B8sZMEzr.js
│   │   ├── dynamics-BIUPVvua.js
│   │   ├── dynamics-BSRBL80o.css
│   │   ├── dynamics-BSXoqs29.js
│   │   ├── dynamics-BklWifEC.js
│   │   ├── dynamics-BuLnUnce.js
│   │   ├── dynamics-C9lfJKMx.js
│   │   ├── dynamics-ClLksIx0.js
│   │   ├── dynamics-CmkAOY7D.js
│   │   ├── dynamics-DJcd-s5t.js
│   │   ├── dynamics-Dhqwo8bA.js
│   │   ├── dynamics-QiFxRnCR.js
│   │   ├── dynamics-hPdJUX6r.js
│   │   ├── el-badge-BWN_0xb6.css
│   │   ├── el-card-fwQOLwdi.css
│   │   ├── el-checkbox-DIj50LEB.css
│   │   ├── el-col-Ds2mGN2S.css
│   │   ├── el-descriptions-item-o9ObloqJ.css
│   │   ├── el-divider-BUtF_RGI.css
│   │   ├── el-empty-D4ZqTl4F.css
│   │   ├── el-form-item-BWkJzdQ_.css
│   │   ├── el-image-viewer-gjGgbSV7.css
│   │   ├── el-input-number-D6iOyBgb.css
│   │   ├── el-input-tPmZxDKr.css
│   │   ├── el-link-B58a4a3I.css
│   │   ├── el-loading-C5IeuJ3V.css
│   │   ├── el-overlay-uHqKdL1G.css
│   │   ├── el-pagination-BNQcHhjS.css
│   │   ├── el-progress-Dw9yTa91.css
│   │   ├── el-radio-button-CSkroacn.css
│   │   ├── el-radio-group-lhPfk_Qw.css
│   │   ├── el-select-DC6_bRTH.css
│   │   ├── el-table-column-CKoPG0Y8.css
│   │   ├── el-tag-DljBBxJR.css
│   │   ├── el-timeline-item-BvbJTz1y.css
│   │   ├── el-tooltip-l0sNRNKZ.js
│   │   ├── el-upload-q8uObtwj.css
│   │   ├── element-plus-B9MrEl8w.js
│   │   ├── element-plus-o-j_G_-z.js
│   │   ├── finance-BAYqADCl.js
│   │   ├── finance-BD5wpG4g.css
│   │   ├── finance-BFR1OC-C.js
│   │   ├── finance-CFzMrBJ5.js
│   │   ├── finance-CStqxaTn.js
│   │   ├── finance-Cnu9C3pH.js
│   │   ├── finance-D-K3kWDR.js
│   │   ├── finance-D8BLPV9z.js
│   │   ├── finance-DDTU0HYd.js
│   │   ├── finance-O7Szauvn.js
│   │   ├── finance-iDTEDZjq.js
│   │   ├── finance-qpJnXvnG.js
│   │   ├── index--sddL_DG.js
│   │   ├── index-1aIGjDF_.js
│   │   ├── index-B0qf3IHr.js
│   │   ├── index-B2-6bV7b.js
│   │   ├── index-B8C77IZt.js
│   │   ├── index-B9Tu-n-f.css
│   │   ├── index-BBvc-XMN.css
│   │   ├── index-BCcbQRi_.js
│   │   ├── index-BDuzG06j.js
│   │   ├── index-BFgFkUhR.js
│   │   ├── index-BI_Q4cjo.js
│   │   ├── index-BK2VXG0n.js
│   │   ├── index-BKVCRXr6.js
│   │   ├── index-BP7Cpww0.js
│   │   ├── index-BQGkfMsO.js
│   │   ├── index-BT7ZNRpg.js
│   │   ├── index-BYydqmxs.js
│   │   ├── index-BaGYIqbM.js
│   │   ├── index-BeNAVYP0.js
│   │   ├── index-BeZeSF5x.js
│   │   ├── index-BiU8_aI7.js
│   │   ├── index-BlMIfOB5.js
│   │   ├── index-BnQMA19Z.css
│   │   ├── index-BrqdZ9MV.js
│   │   ├── index-Bvbank6p.js
│   │   ├── index-ByXUt1Ht.js
│   │   ├── index-C1Gu1ldM.js
│   │   ├── index-C2zwZH3m.js
│   │   ├── index-C4algVp-.js
│   │   ├── index-C7HjTzea.js
│   │   ├── index-C7QMbvNI.js
│   │   ├── index-C8fwhNLU.js
│   │   ├── index-CBIOQEZf.css
│   │   ├── index-CQ1_QnL5.js
│   │   ├── index-Ca3SNM_l.js
│   │   ├── index-CgNOuK1N.js
│   │   ├── index-Cj1do-4s.js
│   │   ├── index-CjZhQ3nS.js
│   │   ├── index-CoRtiVqK.js
│   │   ├── index-CwEf16k7.js
│   │   ├── index-D2CWAnzF.js
│   │   ├── index-D40KseiW.js
│   │   ├── index-D4Btb-iE.js
│   │   ├── index-D9G9YzHt.css
│   │   ├── index-DBDT4uYO.js
│   │   ├── index-DH5c_PcU.js
│   │   ├── index-DIIZ4_FJ.js
│   │   ├── index-DYmilcEN.js
│   │   ├── index-Dj1k6lBS.js
│   │   ├── index-DnjN8ieL.js
│   │   ├── index-DsNOaJLU.js
│   │   ├── index-Gupr2Qtl.js
│   │   ├── index-JaZdKMuh.js
│   │   ├── index-QtCBLM6r.js
│   │   ├── index-SM0C544p.js
│   │   ├── index-TOGuZ6Gu.js
│   │   ├── index-YaKkPaKk.js
│   │   ├── index-Z-ZaoBYZ.js
│   │   ├── index-cLv6ztlq.js
│   │   ├── index-k_aWam8k.js
│   │   ├── index-lz1FAUu8.js
│   │   ├── index-ol3VzvfB.js
│   │   ├── index-t6b5srCu.js
│   │   ├── index-te9N7g2Y.js
│   │   ├── index-zydmklbY.js
│   │   ├── layout-BErD20-2.js
│   │   ├── layout-Ba3nNnOZ.js
│   │   ├── layout-BeXvC3fC.js
│   │   ├── layout-CC5sDjoO.js
│   │   ├── layout-CGTEgh_C.js
│   │   ├── layout-CTPkLgK-.js
│   │   ├── layout-CahFuOv0.css
│   │   ├── layout-Cfs5kHj4.js
│   │   ├── layout-CmQGZUZk.js
│   │   ├── layout-DNWE8lsa.css
│   │   ├── layout-Dwa5NzYW.js
│   │   ├── layout-I3Ju9RwM.js
│   │   ├── layout-Z-RkrRNs.js
│   │   ├── layout-ixQb5h3p.js
│   │   ├── list-B-zu6xVz.js
│   │   ├── list-BAV91x9H.js
│   │   ├── list-BAd66jpt.js
│   │   ├── list-BM6nIiCi.js
│   │   ├── list-BRN_ufzC.js
│   │   ├── list-BYEgBSJ1.js
│   │   ├── list-Be42q6qZ.js
│   │   ├── list-BnLEAQex.js
│   │   ├── list-BsJem37y.js
│   │   ├── list-BzwMAolz.js
│   │   ├── list-C27jyUwZ.css
│   │   ├── list-C6mS0HuM.css
│   │   ├── list-C9vU5UNw.js
│   │   ├── list-CA2QIO3p.js
│   │   ├── list-CAfNJiB0.js
│   │   ├── list-CH6MQsX9.js
│   │   ├── list-CPCocKt6.js
│   │   ├── list-CTWhVlC8.js
│   │   ├── list-CfGk74S1.js
│   │   ├── list-ChtJ9ze3.js
│   │   ├── list-CiB2_dsV.css
│   │   ├── list-CsA4MJgw.js
│   │   ├── list-CwrWcPIy.js
│   │   ├── list-DDJKuXnP.js
│   │   ├── list-DIOaMdVe.js
│   │   ├── list-DIzxUJzS.js
│   │   ├── list-DJTRv8Dj.css
│   │   ├── list-DM51Vhnu.css
│   │   ├── list-DYEUj21o.css
│   │   ├── list-DdSF0hia.js
│   │   ├── list-De9MRS2m.js
│   │   ├── list-DqJfd2HY.js
│   │   ├── list-DqqS4-iG.js
│   │   ├── list-DsttkqMS.js
│   │   ├── list-KlG0iGbX.js
│   │   ├── list-LXGJRGVB.js
│   │   ├── list-Lway8N45.js
│   │   ├── list-YxrLKoSD.js
│   │   ├── list-aKeslsYs.js
│   │   ├── list-hhsuxR4p.js
│   │   ├── list-roWj8-7Y.js
│   │   ├── list-sES8N36g.js
│   │   ├── login-0NJPAjYM.js
│   │   ├── login-5DrROgV0.js
│   │   ├── login-B5YQ42Zr.css
│   │   ├── login-BLBKis2t.js
│   │   ├── login-BZPQMBXT.css
│   │   ├── login-Cd9CZ2mo.js
│   │   ├── login-CtzQ2cfg.js
│   │   ├── login-DIBi6VDb.js
│   │   ├── login-DVYCgaKb.js
│   │   ├── login-DYKvM-bx.js
│   │   ├── login-Dzlzp2m-.js
│   │   ├── login-GWPlTyEW.js
│   │   ├── login-OOmYdJkL.js
│   │   ├── login-OSfBRBfc.js
│   │   ├── my-BIbcXChr.js
│   │   ├── my-BQgaUGm-.js
│   │   ├── my-BXrcXQ9I.js
│   │   ├── my-BuccqMLt.css
│   │   ├── my-C1_rGSGG.js
│   │   ├── my-CEpycpQo.js
│   │   ├── my-CJR_Dw9P.js
│   │   ├── my-CbO5_4C-.js
│   │   ├── my-CiTK11YC.js
│   │   ├── my-CpkQOgV8.js
│   │   ├── my-DNbPBbAU.js
│   │   ├── my-DXGQtCuo.js
│   │   ├── my-DxuX_-Uj.js
│   │   ├── notification-B4kEBSNC.js
│   │   ├── notification-BVfS3hTn.js
│   │   ├── notification-C5-tQjV5.js
│   │   ├── notification-Cesp0kKj.js
│   │   ├── notification-Czc7qxhh.js
│   │   ├── notification-D3HbaKbv.js
│   │   ├── notification-DObBmXYi.js
│   │   ├── notification-DY3IOnEd.js
│   │   ├── notification-DaBknuMT.js
│   │   ├── notification-DroLapJk.js
│   │   ├── notification-aPpcSc-s.js
│   │   ├── notifications-ACEtb9sY.js
│   │   ├── notifications-BaBxdlop.js
│   │   ├── notifications-Bp4yn636.js
│   │   ├── notifications-CZFS_L_U.js
│   │   ├── notifications-Chsa1Nl4.js
│   │   ├── notifications-DNxuEz_H.css
│   │   ├── notifications-DsKr-DbA.js
│   │   ├── notifications-DxqicTjd.js
│   │   ├── notifications-ISMU7-u7.js
│   │   ├── notifications-P3yURfqg.js
│   │   ├── notifications-R_OSO6UU.js
│   │   ├── notifications-ubxKxkzJ.js
│   │   ├── profile-BM_NAdfr.js
│   │   ├── profile-Bm2Nw2vb.css
│   │   ├── profile-CCB-Pmuq.js
│   │   ├── profile-C_Aqnpnt.js
│   │   ├── profile-CcB5aJhR.js
│   │   ├── profile-Cg3Fe27S.js
│   │   ├── profile-CjbDAEUJ.css
│   │   ├── profile-D5HoZgfE.js
│   │   ├── profile-DSuGEjLL.js
│   │   ├── profile-Dv5dm9_t.js
│   │   ├── profile-EULMiEB6.js
│   │   ├── profile-HKK3feR-.js
│   │   ├── profile-aQV4DTK_.js
│   │   ├── profile-k8PRkcFQ.js
│   │   ├── publish-0B6aPEyx.js
│   │   ├── publish-6j-ShRGN.js
│   │   ├── publish-B6dxvGfH.js
│   │   ├── publish-BNo6pCu5.js
│   │   ├── publish-BSBam8yK.js
│   │   ├── publish-BhTfHwau.css
│   │   ├── publish-BtEgJz0V.js
│   │   ├── publish-C3s_l0RV.js
│   │   ├── publish-C61PRq3d.js
│   │   ├── publish-CCC1E7U_.js
│   │   ├── publish-CVaKFtcd.js
│   │   ├── publish-CW-OQiuw.js
│   │   ├── publish-C_uQ8JTs.js
│   │   ├── publish-Cl-E1SLJ.js
│   │   ├── publish-D4_DahGP.js
│   │   ├── publish-D9H4oIhv.js
│   │   ├── publish-DCNMYsX3.js
│   │   ├── publish-DI1B7523.js
│   │   ├── publish-DOavOoYh.js
│   │   ├── publish-DXgdqvUG.css
│   │   ├── publish-DbRkYaS3.js
│   │   ├── publish-DpwfsBzO.js
│   │   ├── publish-DqBdqdfD.js
│   │   ├── publish-DtLcVmi6.js
│   │   ├── publish-aZQqJqJi.js
│   │   ├── publish-eDZjxJad.js
│   │   ├── register-9u80BRhS.js
│   │   ├── register-BB1ngGKf.js
│   │   ├── register-BVz-42mk.js
│   │   ├── register-BahgS4Y2.css
│   │   ├── register-COOE4xes.js
│   │   ├── register-CuhzekmD.js
│   │   ├── register-Cw3hblXO.js
│   │   ├── register-DK4l04fd.js
│   │   ├── register-DZryf8Ku.js
│   │   ├── register-Dfm_Pr6O.js
│   │   ├── register-DhitHBN6.js
│   │   ├── register-FYmv8PYr.js
│   │   ├── register-gxlCqZmp.js
│   │   ├── rescue-BLI-UUW_.js
│   │   ├── rescue-BTrqwbQs.js
│   │   ├── rescue-B_3geFeJ.js
│   │   ├── rescue-BfvfAiuu.js
│   │   ├── rescue-BgFAj9bP.js
│   │   ├── rescue-Clc9l849.js
│   │   ├── rescue-CloAfOhb.js
│   │   ├── rescue-Cluz7_aJ.js
│   │   ├── rescue-DAFdk1R_.js
│   │   ├── rescue-DECkZGOU.js
│   │   ├── rescue-DQ86LqSP.js
│   │   ├── rescue-asa8I2FB.js
│   │   ├── rescues-4__s_sJA.js
│   │   ├── rescues-B2KZdLpk.js
│   │   ├── rescues-B2QngdPd.js
│   │   ├── rescues-BGi68crS.js
│   │   ├── rescues-BHptdM3k.js
│   │   ├── rescues-BUEAtbtW.js
│   │   ├── rescues-CPBftpkb.js
│   │   ├── rescues-DDfzsZ_T.js
│   │   ├── rescues-Dk5449cQ.js
│   │   ├── rescues-e6ASUFHB.js
│   │   ├── rescues-iX73SO3l.js
│   │   ├── rescues-spEzC6Fl.css
│   │   ├── rescues-xXb8g9rn.js
│   │   ├── universities-0tL6kaJH.js
│   │   ├── universities-B9pskzJg.js
│   │   ├── universities-BkerddsD.js
│   │   ├── universities-C0yhnoQf.css
│   │   ├── universities-CHuIuoL5.js
│   │   ├── universities-CRUL3s_H.js
│   │   ├── universities-CjvjJiZM.js
│   │   ├── universities-Cyh3tREU.js
│   │   ├── universities-CzRtf8BY.js
│   │   ├── universities-D2W8IwaH.js
│   │   ├── universities-Ds7Yi4UB.js
│   │   ├── universities-DsXW6mHf.js
│   │   ├── users-7-Y_dvjV.js
│   │   ├── users-B0OL_xP8.js
│   │   ├── users-BF24uGdZ.js
│   │   ├── users-BbjfzFHJ.css
│   │   ├── users-BhP7txGO.js
│   │   ├── users-Bxf5GH1t.js
│   │   ├── users-CRFj0g4o.js
│   │   ├── users-Cn5Io2Jk.js
│   │   ├── users-Cw59rTtM.js
│   │   ├── users-DCzT3ySi.js
│   │   ├── users-DNQM7Hz0.js
│   │   ├── users-oJCLaSD0.js
│   │   ├── users-v5VLNE8k.js
│   │   ├── utils-CCXpdI6d.js
│   │   ├── utils-DtAJ10D1.js
│   │   ├── verifications-59yfvq-K.css
│   │   ├── verifications-B5vNM-gk.js
│   │   ├── verifications-BSDEA4tV.js
│   │   ├── verifications-BSsXGnzL.js
│   │   ├── verifications-Ba4wgz1C.js
│   │   ├── verifications-BkbEYjzX.js
│   │   ├── verifications-CqZRSEhf.js
│   │   ├── verifications-DWrijya1.js
│   │   ├── verifications-DZgpKCvu.js
│   │   ├── verifications-Dfnugfqi.js
│   │   ├── verifications-Ds48watt.js
│   │   ├── verifications-M5gdGE4h.js
│   │   ├── vue-vendor-L7KxampG.js
│   │   ├── zh-cn-qMXBDFIZ.js
│   │   └── zh-cn-zKIttnm5.js
│   ├── frontend.log
│   ├── images
│   ├── index.html
│   ├── serve.json
│   ├── server.js
│   ├── uploads
│   │   ├── avatar
│   │   ├── cats
│   │   ├── dynamic
│   │   └── rescue
│   └── 启动前端.bat
├── init-db.bat
├── nginx
│   ├── admin.conf
│   ├── frontend.conf
│   └── nginx.test.conf
├── nul
├── start.bat.old
├── stop.bat.old
├── uploads
│   ├── avatar
│   │   ├── admin.jpg
│   │   ├── lisi.jpg
│   │   ├── volunteer1.jpg
│   │   ├── wangwu.jpg
│   │   ├── zhangsan.jpg
│   │   └── zhaoliu.jpg
│   ├── cats
│   │   ├── cat1.jpg
│   │   ├── cat10.jpg
│   │   ├── cat10_1.jpg
│   │   ├── cat10_2.jpg
│   │   ├── cat1_1.jpg
│   │   ├── cat1_2.jpg
│   │   ├── cat1_3.jpg
│   │   ├── cat2.jpg
│   │   ├── cat2_1.jpg
│   │   ├── cat2_2.jpg
│   │   ├── cat3.jpg
│   │   ├── cat3_1.jpg
│   │   ├── cat3_2.jpg
│   │   ├── cat4.jpg
│   │   ├── cat4_1.jpg
│   │   ├── cat4_2.jpg
│   │   ├── cat4_3.jpg
│   │   ├── cat5.jpg
│   │   ├── cat5_1.jpg
│   │   ├── cat5_2.jpg
│   │   ├── cat6.jpg
│   │   ├── cat6_1.jpg
│   │   ├── cat6_2.jpg
│   │   ├── cat7.jpg
│   │   ├── cat7_1.jpg
│   │   ├── cat7_2.jpg
│   │   ├── cat8.jpg
│   │   ├── cat8_1.jpg
│   │   ├── cat8_2.jpg
│   │   ├── cat9.jpg
│   │   ├── cat9_1.jpg
│   │   └── cat9_2.jpg
│   ├── dynamic
│   │   ├── d1.jpg
│   │   ├── d2.jpg
│   │   ├── d3.jpg
│   │   ├── d4.jpg
│   │   ├── d5.jpg
│   │   ├── dynamic1.jpg
│   │   ├── dynamic2.jpg
│   │   ├── dynamic3.jpg
│   │   ├── dynamic4.jpg
│   │   ├── dynamic5.jpg
│   │   └── dynamic6.jpg
│   └── rescue
│       ├── rescue1.jpg
│       ├── rescue2.jpg
│       ├── rescue3.jpg
│       └── rescue4.jpg
├── 一键启动.bat
├── 修复后端连接.bat
├── 停止服务.bat
├── 启动指南.txt
├── 启动脚本完善说明.md
├── 启动说明.md
├── 完整启动.bat
├── 快速访问指南.txt
├── 查看状态.bat
├── 登录问题诊断.md
├── 社区动态说明.md
├── 管理后台使用说明.md
├── 系统完善方案.md
└── 閮ㄧ讲璇存槑.md

30 directories, 650 files
```

### cat backend/application-prod.yml
```
# 生产环境配置
spring:
  # 静态资源配置 - 让后端同时提供前端页面
  web:
    resources:
      static-locations: classpath:/static/,file:../frontend/,file:../uploads/
      add-mappings: true
  mvc:
    static-path-pattern: /**

  # 数据源配置
  datasource:
    url: jdbc:mysql://localhost:3306/cat_rescue?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456

# CORS配置
cors:
  allowed-origins: http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001

# 文件上传路径
file:
  upload-path: ../uploads/

# JWT配置
jwt:
  secret: cat-rescue-jwt-secret-key-2024-very-long-string-for-security-purpose-32chars

# 日志级别 - 生产环境减少日志
logging:
  level:
    com.campus.cat: info
    com.campus.cat.module.*.mapper: warn
```

### grep -R "localhost:8080" -n ./frontend ./admin-frontend
```
./frontend/server.js:32:      headers: { ...req.headers, host: 'localhost:8080' }
./frontend/AGENTS.md:13:- `server.js` proxies `/api/*` to `http://localhost:8080`.
./admin-frontend/api-test.html:99:        const API_BASE = 'http://localhost:8080/api';
./admin-frontend/api-test.html:120:                resultEl.textContent = `错误: ${error.message}\n\n请确保后端服务已启动在 http://localhost:8080`;
./admin-frontend/新版管理后台说明.md:6:确保后端服务已经启动并运行在 `http://localhost:8080`
./admin-frontend/新版管理后台说明.md:126:1. 检查后端服务是否运行：访问 `http://localhost:8080/api/health`
./admin-frontend/js/api.js:2:const API_BASE = 'http://localhost:8080/api';
./admin-frontend/API接口问题修复说明.md:37:   - 前端请求：`http://localhost:8080/api/admin/users/statistics`
./admin-frontend/API接口问题修复说明.md:38:   - 后端实际：`http://localhost:8080/api/users/statistics`
./admin-frontend/API接口问题修复说明.md:204:   - 使用Swagger UI查看：`http://localhost:8080/swagger-ui.html`
./admin-frontend/login.html:139:        const API_BASE = 'http://localhost:8080/api';
./admin-frontend/dashboard.html:220:        const API_BASE = 'http://localhost:8080/api';
./admin-frontend/AGENTS.md:13:- API base URL is hardcoded in `js/api.js` as `http://localhost:8080/api`.
```

### grep -R "/api" -n ./frontend ./admin-frontend | head
```
./frontend/api-test.html:129:                const response = await fetch('/api/users/login', {
./frontend/api-test.html:212:                { name: '猫咪列表', url: '/api/cats/page?current=1&size=10' },
./frontend/api-test.html:213:                { name: '社区动态', url: '/api/dynamics/page?current=1&size=10' },
./frontend/api-test.html:214:                { name: '热门话题', url: '/api/community/hot-topics?limit=5' },
./frontend/api-test.html:215:                { name: '活跃用户', url: '/api/community/active-users?limit=5' },
./frontend/api-test.html:216:                { name: '用户信息', url: '/api/users/info' },
./frontend/api-test.html:217:                { name: '用户统计', url: '/api/users/stats' },
./frontend/api-test.html:218:                { name: '猫咪统计', url: '/api/cats/stats' },
./frontend/api-test.html:219:                { name: '领养列表', url: '/api/adoptions/page?current=1&size=10' },
./frontend/api-test.html:220:                { name: '救助信息', url: '/api/rescue-info/page?current=1&size=10' }
```

### ls -lah backend/*.jar
```
-rw-rw-rw-@ 1 yuchenxu  staff    59M Feb  1 08:55 backend/cat-rescue.jar
```

### 端口占用
```
COMMAND    PID     USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
ControlCe 1057 yuchenxu   10u  IPv4 0x15beb8fa2033377b      0t0  TCP *:5000 (LISTEN)
ControlCe 1057 yuchenxu   11u  IPv6 0x53c3e640d313fbfd      0t0  TCP *:5000 (LISTEN)
COMMAND   PID     USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
Python  65008 yuchenxu    7u  IPv4 0x4ddca8d30471f395      0t0  TCP *:5001 (LISTEN)
Python  65008 yuchenxu   10u  IPv4 0x4ddca8d30471f395      0t0  TCP *:5001 (LISTEN)
Python  91805 yuchenxu    7u  IPv4 0x4ddca8d30471f395      0t0  TCP *:5001 (LISTEN)
COMMAND   PID     USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
java    96877 yuchenxu   18u  IPv6 0xb7978d1ccdff2181      0t0  TCP *:8080 (LISTEN)
```

## 1. 后端配置可配置化

### application-prod.yml diff
```diff
--- deploy/PATCHES/application-prod.yml.20260208_102329.bak	2026-02-08 10:23:29
+++ deploy/backend/application-prod.yml	2026-02-08 10:23:42
@@ -1,4 +1,7 @@
 # 生产环境配置
+server:
+  port: ${APP_PORT:8080}
+
 spring:
   # 静态资源配置 - 让后端同时提供前端页面
   web:
@@ -10,13 +13,13 @@
 
   # 数据源配置
   datasource:
-    url: jdbc:mysql://localhost:3306/cat_rescue?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
-    username: root
-    password: 123456
+    url: jdbc:mysql://${DB_HOST:localhost}:${DB_PORT:3306}/${DB_NAME:cat_rescue}?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
+    username: ${DB_USER:root}
+    password: ${DB_PASS:123456}
 
 # CORS配置
 cors:
-  allowed-origins: http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001
+  allowed-origins: ${CORS_ALLOWED_ORIGINS:http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001}
 
 # 文件上传路径
 file:
```

### 新增 application-local.yml
```
# 本地开发配置（Mac/Windows）
server:
  port: ${APP_PORT:8080}

spring:
  web:
    resources:
      static-locations: classpath:/static/,file:../frontend/,file:../uploads/
      add-mappings: true
  mvc:
    static-path-pattern: /**

  datasource:
    url: jdbc:mysql://${DB_HOST:127.0.0.1}:${DB_PORT:3306}/${DB_NAME:cat_rescue}?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: ${DB_USER:root}
    password: ${DB_PASS:123456}

cors:
  allowed-origins: ${CORS_ALLOWED_ORIGINS:http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001}

file:
  upload-path: ../uploads/

jwt:
  secret: cat-rescue-jwt-secret-key-2024-very-long-string-for-security-purpose-32chars

logging:
  level:
    com.campus.cat: info
    com.campus.cat.module.*.mapper: warn
```

### 环境变量说明
- APP_PORT: 后端端口（默认 8080）
- DB_HOST/DB_PORT/DB_NAME: 数据库连接（默认 127.0.0.1/3306/cat_rescue）
- DB_USER/DB_PASS: 数据库账号密码（默认 root/123456）
- CORS_ALLOWED_ORIGINS: 允许的前端域名列表

## 2. 启动脚本（无 Docker）

### start_mac.sh
```
#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

APP_PORT="${APP_PORT:-8080}"
API_HOST="${API_HOST:-127.0.0.1}"
API_PORT="${API_PORT:-8080}"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-cat_rescue}"
DB_USER="${DB_USER:-root}"
DB_PASS="${DB_PASS:-123456}"

CORS_ALLOWED_ORIGINS="${CORS_ALLOWED_ORIGINS:-http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001}"
SPRING_PROFILES_ACTIVE="${SPRING_PROFILES_ACTIVE:-local}"

log() {
  printf "[%s] %s\n" "$(date +%H:%M:%S)" "$*"
}

log "检查 Java..."
if ! java -version >/dev/null 2>&1; then
  echo "未检测到 Java，请先安装 Java 17+" >&2
  exit 1
fi
java -version 2>&1 | head -n 1

log "检查 Node.js..."
if ! node -v >/dev/null 2>&1; then
  echo "未检测到 Node.js，请先安装 Node 16+" >&2
  exit 1
fi
node -v

log "检查 MySQL 连接..."
MYSQL_OK=0
if command -v mysqladmin >/dev/null 2>&1; then
  if [ -n "$DB_PASS" ]; then
    mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
  else
    mysqladmin ping -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
  fi
elif command -v nc >/dev/null 2>&1; then
  nc -z "$DB_HOST" "$DB_PORT" >/dev/null 2>&1 && MYSQL_OK=1 || MYSQL_OK=0
fi

if [ "$MYSQL_OK" -ne 1 ]; then
  log "MySQL 未就绪：请确认 MySQL 已启动，并执行 init-db.bat 初始化数据库。"
else
  log "MySQL 端口可达。"
fi

if command -v mysql >/dev/null 2>&1; then
  DB_EXISTS=""
  if [ -n "$DB_PASS" ]; then
    DB_EXISTS=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" -N -s -e "SHOW DATABASES LIKE '$DB_NAME';" 2>/dev/null || true)
  else
    DB_EXISTS=$(mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -N -s -e "SHOW DATABASES LIKE '$DB_NAME';" 2>/dev/null || true)
  fi
  if [ -z "$DB_EXISTS" ]; then
    log "数据库 $DB_NAME 不存在：请先运行初始化脚本。"
  fi
fi

log "启动后端 (端口 $APP_PORT)..."
nohup env \
  APP_PORT="$APP_PORT" \
  DB_HOST="$DB_HOST" DB_PORT="$DB_PORT" DB_NAME="$DB_NAME" DB_USER="$DB_USER" DB_PASS="$DB_PASS" \
  CORS_ALLOWED_ORIGINS="$CORS_ALLOWED_ORIGINS" \
  java -jar backend/cat-rescue.jar --spring.profiles.active="$SPRING_PROFILES_ACTIVE" \
  > backend/backend.log 2>&1 &
BACK_PID=$!
log "后端 PID: $BACK_PID (日志: backend/backend.log)"

log "启动用户前端 (端口 5000)..."
nohup env API_HOST="$API_HOST" API_PORT="$API_PORT" node frontend/server.js > frontend/frontend.log 2>&1 &
FRONT_PID=$!
log "用户前端 PID: $FRONT_PID (日志: frontend/frontend.log)"

log "启动管理后台 (端口 5001)..."
nohup env API_HOST="$API_HOST" API_PORT="$API_PORT" node admin-frontend/server.js > admin-frontend/admin.log 2>&1 &
ADMIN_PID=$!
log "管理后台 PID: $ADMIN_PID (日志: admin-frontend/admin.log)"

sleep 6

log "健康检查..."
health_url="http://127.0.0.1:${APP_PORT}/actuator/health"
health_status=$(curl -sS -o /dev/null -w "%{http_code}" "$health_url" || echo "000")
if [ "$health_status" != "200" ]; then
  alt_url="http://127.0.0.1:${APP_PORT}/api/health"
  alt_status=$(curl -sS -o /dev/null -w "%{http_code}" "$alt_url" || echo "000")
else
  alt_url=""
  alt_status=""
fi

frontend_status=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:5000/" || echo "000")
admin_status=$(curl -sS -o /dev/null -w "%{http_code}" "http://127.0.0.1:5001/" || echo "000")

log "后端健康检查: ${health_url} -> ${health_status}"
if [ -n "$alt_url" ]; then
  log "后端备用检查: ${alt_url} -> ${alt_status}"
fi
log "用户前端: http://127.0.0.1:5000/ -> ${frontend_status}"
log "管理后台: http://127.0.0.1:5001/ -> ${admin_status}"

log "启动完成。"
```

### start_windows.ps1
```
#requires -version 5.1
Set-StrictMode -Version Latest

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

if (-not $env:APP_PORT) { $env:APP_PORT = "8080" }
if (-not $env:API_HOST) { $env:API_HOST = "127.0.0.1" }
if (-not $env:API_PORT) { $env:API_PORT = $env:APP_PORT }

if (-not $env:DB_HOST) { $env:DB_HOST = "127.0.0.1" }
if (-not $env:DB_PORT) { $env:DB_PORT = "3306" }
if (-not $env:DB_NAME) { $env:DB_NAME = "cat_rescue" }
if (-not $env:DB_USER) { $env:DB_USER = "root" }
if (-not $env:DB_PASS) { $env:DB_PASS = "123456" }

if (-not $env:CORS_ALLOWED_ORIGINS) {
  $env:CORS_ALLOWED_ORIGINS = "http://localhost:5173,http://localhost:3000,http://127.0.0.1:5173,http://localhost:5000,http://localhost:5001"
}
if (-not $env:SPRING_PROFILES_ACTIVE) { $env:SPRING_PROFILES_ACTIVE = "local" }

function Write-Log($msg) {
  $ts = (Get-Date).ToString("HH:mm:ss")
  Write-Host "[$ts] $msg"
}

Write-Log "检查 Java..."
try {
  & java -version 2>$null | Out-Null
} catch {
  Write-Error "未检测到 Java，请先安装 Java 17+"
  exit 1
}
& java -version 2>&1 | Select-Object -First 1 | ForEach-Object { Write-Host $_ }

Write-Log "检查 Node.js..."
try {
  & node -v 2>$null | Out-Null
} catch {
  Write-Error "未检测到 Node.js，请先安装 Node 16+"
  exit 1
}
& node -v 2>&1 | Select-Object -First 1 | ForEach-Object { Write-Host $_ }

Write-Log "检查 MySQL 连接..."
$mysqlOk = $false
if (Get-Command mysqladmin -ErrorAction SilentlyContinue) {
  try {
    if ($env:DB_PASS) {
      & mysqladmin ping -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -p$env:DB_PASS | Out-Null
    } else {
      & mysqladmin ping -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER | Out-Null
    }
    $mysqlOk = $true
  } catch {
    $mysqlOk = $false
  }
} else {
  try {
    $tcp = Test-NetConnection -ComputerName $env:DB_HOST -Port $env:DB_PORT -WarningAction SilentlyContinue
    $mysqlOk = $tcp.TcpTestSucceeded
  } catch {
    $mysqlOk = $false
  }
}

if (-not $mysqlOk) {
  Write-Log "MySQL 未就绪：请确认 MySQL 已启动，并执行 init-db.bat 初始化数据库。"
} else {
  Write-Log "MySQL 端口可达。"
}

if (Get-Command mysql -ErrorAction SilentlyContinue) {
  try {
    $dbExists = $null
    if ($env:DB_PASS) {
      $dbExists = & mysql -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -p$env:DB_PASS -N -s -e "SHOW DATABASES LIKE '$($env:DB_NAME)';" 2>$null
    } else {
      $dbExists = & mysql -h $env:DB_HOST -P $env:DB_PORT -u $env:DB_USER -N -s -e "SHOW DATABASES LIKE '$($env:DB_NAME)';" 2>$null
    }
    if (-not $dbExists) {
      Write-Log "数据库 $($env:DB_NAME) 不存在：请先运行初始化脚本。"
    }
  } catch {
    # ignore
  }
}

Write-Log "启动后端 (端口 $($env:APP_PORT))..."
$backendLog = Join-Path $Root "backend\backend.log"
Start-Process -FilePath "java" -ArgumentList @("-jar","cat-rescue.jar","--spring.profiles.active=$($env:SPRING_PROFILES_ACTIVE)") -WorkingDirectory (Join-Path $Root "backend") -RedirectStandardOutput $backendLog -RedirectStandardError $backendLog -NoNewWindow | Out-Null
Write-Log "后端日志: $backendLog"

Write-Log "启动用户前端 (端口 5000)..."
$frontendLog = Join-Path $Root "frontend\frontend.log"
Start-Process -FilePath "node" -ArgumentList @("server.js") -WorkingDirectory (Join-Path $Root "frontend") -RedirectStandardOutput $frontendLog -RedirectStandardError $frontendLog -NoNewWindow | Out-Null
Write-Log "用户前端日志: $frontendLog"

Write-Log "启动管理后台 (端口 5001)..."
$adminLog = Join-Path $Root "admin-frontend\admin.log"
Start-Process -FilePath "node" -ArgumentList @("server.js") -WorkingDirectory (Join-Path $Root "admin-frontend") -RedirectStandardOutput $adminLog -RedirectStandardError $adminLog -NoNewWindow | Out-Null
Write-Log "管理后台日志: $adminLog"

Start-Sleep -Seconds 6

function Get-HttpStatus($url) {
  try {
    $resp = Invoke-WebRequest -UseBasicParsing -Uri $url -Method Get -TimeoutSec 5
    return $resp.StatusCode
  } catch {
    if ($_.Exception.Response) {
      return $_.Exception.Response.StatusCode.value__
    }
    return 0
  }
}

Write-Log "健康检查..."
$healthUrl = "http://127.0.0.1:$($env:APP_PORT)/actuator/health"
$healthStatus = Get-HttpStatus $healthUrl
if ($healthStatus -ne 200) {
  $altUrl = "http://127.0.0.1:$($env:APP_PORT)/api/health"
  $altStatus = Get-HttpStatus $altUrl
}
$frontendStatus = Get-HttpStatus "http://127.0.0.1:5000/"
$adminStatus = Get-HttpStatus "http://127.0.0.1:5001/"

Write-Log "后端健康检查: $healthUrl -> $healthStatus"
if ($altUrl) { Write-Log "后端备用检查: $altUrl -> $altStatus" }
Write-Log "用户前端: http://127.0.0.1:5000/ -> $frontendStatus"
Write-Log "管理后台: http://127.0.0.1:5001/ -> $adminStatus"
Write-Log "启动完成。"
```

### 示例输出格式（示意，非执行）
```
[HH:MM:SS] 检查 Java...
java version "17.x"
[HH:MM:SS] 检查 Node.js...
v16.x.x
[HH:MM:SS] 检查 MySQL 连接...
[HH:MM:SS] MySQL 端口可达。
[HH:MM:SS] 启动后端 (端口 8080)...
[HH:MM:SS] 启动用户前端 (端口 5000)...
[HH:MM:SS] 启动管理后台 (端口 5001)...
[HH:MM:SS] 健康检查...
[HH:MM:SS] 后端健康检查: http://127.0.0.1:8080/actuator/health -> 200
[HH:MM:SS] 用户前端: http://127.0.0.1:5000/ -> 200
[HH:MM:SS] 管理后台: http://127.0.0.1:5001/ -> 200
```

## 3. 前端/管理端 API 基地址统一

### config.js (frontend/admin-frontend)
```
// Runtime API base configuration (can be edited without rebuilding)
window.__API_BASE__ = window.__API_BASE__ || '/api';
```
```
// Runtime API base configuration (can be edited without rebuilding)
window.__API_BASE__ = window.__API_BASE__ || '/api';
```

### grep 证明无硬编码 localhost:8080
```
```

## 4. 管理端登录与鉴权闭环（静态分析）
- 登录请求：POST /api/users/login（login.html 使用表单提交）
- Token 存储：localStorage.admin_token + localStorage.admin_user
- 鉴权头：Authorization: Bearer <token>（common.js ApiClient）
- 入口：layout.html 先 Auth.requireAuth()，通过后加载页面

### 管理端 12 页面 API 使用清单（从 pages/*.html 提取）
```
# adoptions.html
# cat-tags.html
# cats.html
# crowdfunding.html
# dashboard.html
  - API.dashboard.activeUsers
  - API.dashboard.activityStats
  - API.dashboard.pendingTasks
  - API.dashboard.popularCats
  - API.dashboard.recentActivities
  - API.dashboard.statistics
  - API.dashboard.systemHealth
  - API.dashboard.userGrowth
# dynamics.html
# finance.html
# notifications.html
# rescues.html
# universities.html
# users.html
  - API.users.changeRole
  - API.users.changeStatus
  - API.users.create
  - API.users.delete
  - API.users.detail
  - API.users.list
  - API.users.statistics
  - API.users.update
# verifications.html
```

## 5. 云养/捐献/打赏 MVP（基于现有后端 Controller/DTO 证据）

### Controller 路由证据（javap 提取）
```
233:          value=["/page"]
269:          value=["/{id}"]
319:          value=["/my-adoptions"]
358:          value=["/cat/{catId}"]
406:          value=["/expiring-soon"]
510:          value=["/{id}"]
567:          value=["/{id}/cancel"]
622:          value=["/{id}/renew"]
680:          value=["/stats"]
723:          value=["/check-cat-adopted"]
772:      value=["/api/cloud-adoption"]
262:          value=["/page"]
298:          value=["/{id}"]
353:          value=["/my-donations"]
406:          value=["/cat/{catId}"]
467:          value=["/crowdfunding/{crowdfundingId}"]
575:          value=["/{id}/status"]
638:          value=["/total/cat/{catId}"]
683:          value=["/total/crowdfunding/{crowdfundingId}"]
730:          value=["/total/user"]
773:          value=["/ranking/cat/{catId}"]
835:          value=["/ranking/crowdfunding/{crowdfundingId}"]
895:          value=["/stats/user"]
934:          value=["/stats/cat/{catId}"]
983:      value=["/api/donation"]
260:          value=["/page"]
296:          value=["/{id}"]
351:          value=["/my-projects"]
404:          value=["/cat/{catId}"]
465:          value=["/ending-soon"]
525:          value=["/hot"]
629:          value=["/{id}"]
686:          value=["/{id}/activate"]
738:          value=["/{id}/cancel"]
793:          value=["/{id}/progress"]
849:          value=["/stats/{id}"]
899:          value=["/stats/creator"]
927:          value=["/check-status"]
967:      value=["/api/crowdfunding"]
```

### DTO 字段证据（javap -private）
```
Compiled from "CloudAdoptionDTO.java"
public class com.campus.cat.module.cloudadoption.dto.CloudAdoptionDTO {
  private java.lang.Long catId;
  private java.lang.String adoptionName;
  private java.math.BigDecimal monthlyAmount;
  private java.time.LocalDate startDate;
  private java.time.LocalDate endDate;
  private java.lang.String message;
  public com.campus.cat.module.cloudadoption.dto.CloudAdoptionDTO();
  public java.lang.Long getCatId();
  public java.lang.String getAdoptionName();
  public java.math.BigDecimal getMonthlyAmount();
  public java.time.LocalDate getStartDate();
  public java.time.LocalDate getEndDate();
  public java.lang.String getMessage();
  public void setCatId(java.lang.Long);
  public void setAdoptionName(java.lang.String);
  public void setMonthlyAmount(java.math.BigDecimal);
  public void setStartDate(java.time.LocalDate);
  public void setEndDate(java.time.LocalDate);
  public void setMessage(java.lang.String);
  public boolean equals(java.lang.Object);
  protected boolean canEqual(java.lang.Object);
  public int hashCode();
  public java.lang.String toString();
}
Compiled from "DonationDTO.java"
public class com.campus.cat.module.donation.dto.DonationDTO {
  private java.lang.Long catId;
  private java.lang.Long crowdfundingId;
  private java.math.BigDecimal amount;
  private java.lang.String message;
  private java.lang.Boolean isAnonymous;
  private java.lang.String paymentMethod;
  private java.lang.String transactionId;
  public com.campus.cat.module.donation.dto.DonationDTO();
  public java.lang.Long getCatId();
  public java.lang.Long getCrowdfundingId();
  public java.math.BigDecimal getAmount();
  public java.lang.String getMessage();
  public java.lang.Boolean getIsAnonymous();
  public java.lang.String getPaymentMethod();
  public java.lang.String getTransactionId();
  public void setCatId(java.lang.Long);
  public void setCrowdfundingId(java.lang.Long);
  public void setAmount(java.math.BigDecimal);
  public void setMessage(java.lang.String);
  public void setIsAnonymous(java.lang.Boolean);
  public void setPaymentMethod(java.lang.String);
  public void setTransactionId(java.lang.String);
  public boolean equals(java.lang.Object);
  protected boolean canEqual(java.lang.Object);
  public int hashCode();
  public java.lang.String toString();
}
Compiled from "CrowdfundingDTO.java"
public class com.campus.cat.module.crowdfunding.dto.CrowdfundingDTO {
  private java.lang.String title;
  private java.lang.String description;
  private java.lang.Long catId;
  private java.math.BigDecimal targetAmount;
  private java.time.LocalDate startDate;
  private java.time.LocalDate endDate;
  private java.lang.String coverImage;
  private java.util.List<java.lang.String> imageUrls;
  private java.lang.String category;
  private java.lang.String contactInfo;
  private java.lang.String updateMessage;
  public com.campus.cat.module.crowdfunding.dto.CrowdfundingDTO();
  public java.lang.String getTitle();
  public java.lang.String getDescription();
  public java.lang.Long getCatId();
  public java.math.BigDecimal getTargetAmount();
  public java.time.LocalDate getStartDate();
  public java.time.LocalDate getEndDate();
  public java.lang.String getCoverImage();
  public java.util.List<java.lang.String> getImageUrls();
  public java.lang.String getCategory();
  public java.lang.String getContactInfo();
  public java.lang.String getUpdateMessage();
  public void setTitle(java.lang.String);
  public void setDescription(java.lang.String);
  public void setCatId(java.lang.Long);
  public void setTargetAmount(java.math.BigDecimal);
  public void setStartDate(java.time.LocalDate);
  public void setEndDate(java.time.LocalDate);
  public void setCoverImage(java.lang.String);
  public void setImageUrls(java.util.List<java.lang.String>);
  public void setCategory(java.lang.String);
  public void setContactInfo(java.lang.String);
  public void setUpdateMessage(java.lang.String);
  public boolean equals(java.lang.Object);
  protected boolean canEqual(java.lang.Object);
  public int hashCode();
  public java.lang.String toString();
}
```

### SQL 表字段（cat_rescue.sql 片段）
```
UNLOCK TABLES;

--
-- Table structure for table `cloud_adoption`
--

DROP TABLE IF EXISTS `cloud_adoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cloud_adoption` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'äº‘å…»ID',
  `user_id` bigint NOT NULL COMMENT 'äº‘å…»äººID',
  `cat_id` bigint NOT NULL COMMENT 'çŒ«å’ªID',
  `adoption_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'äº‘å…»åç§°',
  `monthly_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'æ¯æœˆäº‘å…»é‡‘é¢',
  `start_date` date DEFAULT NULL COMMENT 'å¼€å§‹äº‘å…»æ—¥æœŸ',
  `end_date` date DEFAULT NULL COMMENT 'ç»“æŸäº‘å…»æ—¥æœŸ',
  `is_active` tinyint DEFAULT '1' COMMENT 'æ˜¯å¦æ´»è·ƒï¼š0-å¦ 1-æ˜¯',
  `total_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'ç´¯è®¡äº‘å…»é‡‘é¢',
  `message` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'äº‘å…»å¯„è¯­',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_cat` (`user_id`,`cat_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_active` (`is_active`),
  CONSTRAINT `cloud_adoption_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cloud_adoption_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `cat` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='äº‘å…»å…³ç³»è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cloud_adoption`
--

LOCK TABLES `cloud_adoption` WRITE;
/*!40000 ALTER TABLE `cloud_adoption` DISABLE KEYS */;
/*!40000 ALTER TABLE `cloud_adoption` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'è¯„è®ºID',
  `dynamic_id` bigint NOT NULL COMMENT 'åŠ¨æ€ID',
  `user_id` bigint NOT NULL COMMENT 'è¯„è®ºäººID',
  `content` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'è¯„è®ºå†…å®¹',
  `parent_id` bigint DEFAULT '0' COMMENT 'çˆ¶è¯„è®ºIDï¼ˆ0è¡¨ç¤ºé¡¶çº§è¯„è®ºï¼‰',
  `reply_to_user_id` bigint DEFAULT NULL COMMENT 'å›žå¤ç›®æ ‡ç”¨æˆ·ID',
  `like_count` int DEFAULT '0' COMMENT 'ç‚¹èµžæ•°',
  `audit_status` enum('PENDING','APPROVED','REJECTED') COLLATE utf8mb4_unicode_ci DEFAULT 'APPROVED' COMMENT 'å®¡æ ¸çŠ¶æ€ï¼šå¾…å®¡æ ¸/å·²é€šè¿‡/å·²æ‹’ç»',
  `audit_user_id` bigint DEFAULT NULL COMMENT 'å®¡æ ¸äººID',
  `audit_time` datetime DEFAULT NULL COMMENT 'å®¡æ ¸æ—¶é—´',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  `is_deleted` tinyint DEFAULT '0' COMMENT 'æ˜¯å¦åˆ é™¤ï¼š0-å¦ 1-æ˜¯',
  PRIMARY KEY (`id`),
  KEY `idx_dynamic_id` (`dynamic_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `reply_to_user_id` (`reply_to_user_id`),
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`dynamic_id`) REFERENCES `cat_dynamic` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `comment_ibfk_3` FOREIGN KEY (`reply_to_user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='è¯„è®ºè¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `crowdfunding`
--

DROP TABLE IF EXISTS `crowdfunding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `crowdfunding` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ä¼—ç­¹ID',
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é¡¹ç›®æ ‡é¢˜',
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'é¡¹ç›®æè¿°',
  `cat_id` bigint DEFAULT NULL COMMENT 'å…³è”çŒ«å’ªIDï¼ˆå¯é€‰ï¼‰',
  `creator_id` bigint NOT NULL COMMENT 'å‘èµ·äººID',
  `target_amount` decimal(10,2) NOT NULL COMMENT 'ç›®æ ‡é‡‘é¢',
  `current_amount` decimal(10,2) DEFAULT '0.00' COMMENT 'å½“å‰é‡‘é¢',
  `start_date` date DEFAULT NULL COMMENT 'å¼€å§‹æ—¥æœŸ',
  `end_date` date DEFAULT NULL COMMENT 'ç»“æŸæ—¥æœŸ',
  `status` enum('DRAFT','ACTIVE','COMPLETED','FAILED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT' COMMENT 'çŠ¶æ€ï¼šè‰ç¨¿/è¿›è¡Œä¸­/å·²å®Œæˆ/å·²å¤±è´¥/å·²å–æ¶ˆ',
  `cover_image` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'å°é¢å›¾ç‰‡',
  `image_urls` text COLLATE utf8mb4_unicode_ci COMMENT 'é¡¹ç›®å›¾ç‰‡ï¼ˆJSONæ ¼å¼ï¼‰',
  `category` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'é¡¹ç›®åˆ†ç±»',
  `contact_info` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'è”ç³»æ–¹å¼',
  `update_message` text COLLATE utf8mb4_unicode_ci COMMENT 'é¡¹ç›®è¿›å±•æ›´æ–°',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_creator_id` (`creator_id`),
  KEY `idx_status` (`status`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='ä¼—ç­¹é¡¹ç›®è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `crowdfunding`
--

LOCK TABLES `crowdfunding` WRITE;
/*!40000 ALTER TABLE `crowdfunding` DISABLE KEYS */;
INSERT INTO `crowdfunding` VALUES (1,'团团皮肤病治疗费用','团团正在接受皮肤病治疗，预计需要治疗费用2000元，希望大家能帮助它渡过难关。',7,3,2000.00,1350.00,'2024-10-20','2024-12-20','ACTIVE',NULL,NULL,NULL,NULL,NULL,'2026-01-04 14:48:56','2026-01-19 22:10:35'),(2,'小橘绝育疫苗费用','小橘需要进行绝育手术和疫苗接种，预计费用800元。',6,5,800.00,450.00,'2024-11-15','2024-12-31','ACTIVE',NULL,NULL,NULL,NULL,NULL,'2026-01-04 14:48:56','2026-01-19 22:10:35');
/*!40000 ALTER TABLE `crowdfunding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `donation`
--

DROP TABLE IF EXISTS `donation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `donation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'æèµ ID',
  `user_id` bigint NOT NULL COMMENT 'æèµ äººID',
  `cat_id` bigint DEFAULT NULL COMMENT 'çŒ«å’ªIDï¼ˆå¯é€‰ï¼‰',
  `crowdfunding_id` bigint DEFAULT NULL COMMENT 'ä¼—ç­¹é¡¹ç›®ID',
  `amount` decimal(10,2) NOT NULL COMMENT 'æèµ é‡‘é¢',
  `payment_method` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'æ”¯ä»˜æ–¹å¼',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ç¬¬ä¸‰æ–¹äº¤æ˜“å·',
  `status` enum('PENDING','SUCCESS','FAILED','REFUNDED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING' COMMENT 'çŠ¶æ€',
  `message` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ç•™è¨€',
  `is_anonymous` tinyint(1) DEFAULT '0' COMMENT 'æ˜¯å¦åŒ¿å',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'åˆ›å»ºæ—¶é—´',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'æ›´æ–°æ—¶é—´',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_crowdfunding_id` (`crowdfunding_id`),
  KEY `idx_status` (`status`),
  KEY `idx_cat_id` (`cat_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='æèµ è®°å½•è¡¨';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `donation`
--

LOCK TABLES `donation` WRITE;
/*!40000 ALTER TABLE `donation` DISABLE KEYS */;
INSERT INTO `donation` VALUES (1,4,NULL,1,200.00,'WECHAT',NULL,'SUCCESS','团团加油！',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(2,6,NULL,1,100.00,'ALIPAY',NULL,'SUCCESS','希望早日康复',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(3,2,NULL,1,500.00,'WECHAT',NULL,'SUCCESS','支持流浪猫救助',1,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(4,4,NULL,1,300.00,'WECHAT',NULL,'SUCCESS','再捐一点',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(5,6,NULL,1,250.00,'ALIPAY',NULL,'SUCCESS','',0,'2026-01-04 14:48:56','2026-01-19 22:34:09'),(6,4,NULL,2,200.00,'WECHAT',NULL,'SUCCESS','小橘要健康',0,'2026-01-04 14:48:56','2026-01-19 22:53:27'),(7,2,NULL,2,150.00,'ALIPAY',NULL,'SUCCESS','',0,'2026-01-04 14:48:56','2026-01-19 22:34:09'),(8,6,NULL,2,100.00,'WECHAT',NULL,'SUCCESS','加油',0,'2026-01-04 14:48:56','2026-01-19 22:53:27');
/*!40000 ALTER TABLE `donation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `finance`
--

DROP TABLE IF EXISTS `finance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
```

### MVP 页面文件（frontend/mvp）
```
cloud-adoption-detail.html
cloud-adoption-list.html
cloud-adoption-mine.html
cloud-adoption-order.html
donation-detail.html
donation-mine.html
donation-new.html
donation-projects.html
mvp-login.html
mvp.css
mvp.js
tip.html
```

### MVP 页面与 API 路由映射
- 云养列表: /mvp/cloud-adoption-list.html -> GET /api/cloud-adoption/page
- 云养详情: /mvp/cloud-adoption-detail.html -> GET /api/cloud-adoption/{id}
- 发起云养: /mvp/cloud-adoption-order.html -> POST /api/cloud-adoption
- 我的云养: /mvp/cloud-adoption-mine.html -> GET /api/cloud-adoption/my-adoptions
- 捐献项目列表: /mvp/donation-projects.html -> GET /api/crowdfunding/page
- 捐献项目详情: /mvp/donation-detail.html -> GET /api/crowdfunding/{id}
- 发起捐献: /mvp/donation-new.html -> POST /api/donation
- 我的捐献: /mvp/donation-mine.html -> GET /api/donation/my-donations
- 打赏(复用捐献): /mvp/tip.html -> POST /api/donation (catId + amount)

### SQL 字段映射说明
- cloud_adoption: catId->cat_id, adoptionName->adoption_name, monthlyAmount->monthly_amount, startDate->start_date, endDate->end_date, message->message
- donation: catId->cat_id, crowdfundingId->crowdfunding_id, amount->amount, paymentMethod->payment_method, transactionId->transaction_id, isAnonymous->is_anonymous, message->message
- crowdfunding: title->title, description->description, catId->cat_id, targetAmount->target_amount, startDate->start_date, endDate->end_date, coverImage->cover_image, imageUrls->image_urls, category->category, contactInfo->contact_info, updateMessage->update_message

### curl 示例（需后端与数据库可用）
```bash
# 登录获取 token（示例）
curl -s -X POST "http://127.0.0.1:8080/api/users/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=admin&password=123456"

# 发起云养
curl -s -X POST "http://127.0.0.1:8080/api/cloud-adoption" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"catId":1,"adoptionName":"云养小橘","monthlyAmount":99.00,"startDate":"2026-02-01","endDate":"2026-05-01","message":"加油"}'

# 发起捐献
curl -s -X POST "http://127.0.0.1:8080/api/donation" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"crowdfundingId":1,"amount":50.00,"paymentMethod":"WECHAT","isAnonymous":false,"message":"支持"}'
```

## 6. 变更记录（新增/修改文件）
- 修改: backend/application-prod.yml（环境变量可配置）
- 新增: backend/application-local.yml
- 新增: start_mac.sh, start_windows.ps1
- 新增: README_WINDOWS.md, README_MAC.md
- 新增: frontend/config.js, admin-frontend/config.js
- 修改: frontend/server.js, frontend/index.html
- 修改: admin-frontend/server.js, admin-frontend/js/api.js, admin-frontend/login.html, admin-frontend/dashboard.html, admin-frontend/api-test.html, admin-frontend/layout.html
- 修改: frontend/AGENTS.md, admin-frontend/AGENTS.md, admin-frontend/API接口问题修复说明.md, admin-frontend/新版管理后台说明.md
- 新增: frontend/mvp/*（云养/捐献/打赏 MVP 页面）
- 新增: .jar-inspect（仅用于读取 Controller/DTO 证据）

## 5.x 数据库可达性检查（本机）

### mysqladmin ping
```
mysqladmin: [Warning] Using a password on the command line interface can be insecure.
mysqladmin: connect to server at '127.0.0.1' failed
error: 'Access denied for user 'root'@'localhost' (using password: YES)'
```

### mysql 读取测试
```
mysql: [Warning] Using a password on the command line interface can be insecure.
ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: YES)
```

## 7. 补丁文件
- PATCHES/fix_20260208_103850.patch

### server.js 代理逻辑（前端/管理端）
```
deploy/frontend/server.js:6:const API_HOST = process.env.API_HOST || '127.0.0.1';
deploy/frontend/server.js:7:const API_PORT = Number.parseInt(process.env.API_PORT || '8080', 10);
deploy/frontend/server.js:28:  if (pathname.startsWith('/api/')) {
deploy/frontend/server.js:30:      hostname: API_HOST,
deploy/frontend/server.js:31:      port: API_PORT,
deploy/frontend/server.js:34:      headers: { ...req.headers, host: `${API_HOST}:${API_PORT}` }
deploy/admin-frontend/server.js:6:const API_HOST = process.env.API_HOST || '127.0.0.1';
deploy/admin-frontend/server.js:7:const API_PORT = Number.parseInt(process.env.API_PORT || '8080', 10);
deploy/admin-frontend/server.js:25:  if (pathname.startsWith('/api/')) {
deploy/admin-frontend/server.js:27:      hostname: API_HOST,
deploy/admin-frontend/server.js:28:      port: API_PORT,
deploy/admin-frontend/server.js:31:      headers: { ...req.headers, host: `${API_HOST}:${API_PORT}` }
```
