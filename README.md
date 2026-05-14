# aiTools

查看各子模块的README.md

## 发布

```bash
./release.sh           # patch +1  (v1.0.4 -> v1.0.5)
./release.sh minor     # minor +1  (v1.0.5 -> v1.1.0)
./release.sh major     # major +1  (v1.1.0 -> v2.0.0)
```

自动更新 `extension.yml` 版本号、commit、push 并创建 GitHub Release。
