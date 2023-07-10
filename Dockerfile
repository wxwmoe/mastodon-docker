FROM tootsuite/mastodon:v4.1.4

COPY --chown=991:991 ./icons /opt/mastodon/app/javascript/icons
COPY --chown=991:991 ./images /opt/mastodon/app/javascript/images

RUN echo "修改字数上限" \
  && sed -i "s|MAX_CHARS = 500|MAX_CHARS = 20000|" /opt/mastodon/app/validators/status_length_validator.rb \
  && sed -i "s|length(fulltext) > 500|length(fulltext) > 20000|" /opt/mastodon/app/javascript/mastodon/features/compose/components/compose_form.js \
  && sed -i "s|CharacterCounter max={500}|CharacterCounter max={20000}|" /opt/mastodon/app/javascript/mastodon/features/compose/components/compose_form.js \
  && echo "修改媒体上限" \
  && sed -i "s|MAX_IMAGE_PIXELS = 2073600|MAX_IMAGE_PIXELS = 9999999|" /opt/mastodon/app/javascript/mastodon/utils/resize_image.js \
  && sed -i "s|pixels: 2_073_600|pixels: 9_999_999|" /opt/mastodon/app/models/media_attachment.rb \
  && sed -i "s|IMAGE_LIMIT = 10|IMAGE_LIMIT = 80|" /opt/mastodon/app/models/media_attachment.rb \
  && sed -i "s|VIDEO_LIMIT = 40|VIDEO_LIMIT = 100|" /opt/mastodon/app/models/media_attachment.rb \
  && echo "修改投票上限" \
  && sed -i "s|options.size >= 4|options.size >= 16|" /opt/mastodon/app/javascript/mastodon/features/compose/components/poll_form.js \
  && sed -i "s|MAX_OPTIONS      = 4|MAX_OPTIONS      = 16|" /opt/mastodon/app/validators/poll_validator.rb \
  && echo "加入 No-More-Sidebar-in-Mastodon-4.0 主题" \
  && mkdir /opt/mastodon/app/javascript/styles/mastodon-no-more-sidebar \
  && wget -nv https://raw.githubusercontent.com/AkazaRenn/No-More-Sidebar-in-Mastodon-4.0/main/css/topbar.css -O /opt/mastodon/app/javascript/styles/mastodon-no-more-sidebar/topbar.scss \
  && wget -nv https://raw.githubusercontent.com/AkazaRenn/No-More-Sidebar-in-Mastodon-4.0/main/css/bottombar.css -O /opt/mastodon/app/javascript/styles/mastodon-no-more-sidebar/bottombar.scss \
  && cp /opt/mastodon/app/javascript/styles/contrast.scss /opt/mastodon/app/javascript/styles/contrast-topbar.scss \
  && cp /opt/mastodon/app/javascript/styles/contrast.scss /opt/mastodon/app/javascript/styles/contrast-bottombar.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light.scss /opt/mastodon/app/javascript/styles/mastodon-light-topbar.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light.scss /opt/mastodon/app/javascript/styles/mastodon-light-bottombar.scss \
  && echo -e "@import 'application';\n@import 'mastodon-no-more-sidebar/topbar';" > /opt/mastodon/app/javascript/styles/mastodon-dark-topbar.scss \
  && echo -e "@import 'application';\n@import 'mastodon-no-more-sidebar/bottombar';" > /opt/mastodon/app/javascript/styles/mastodon-dark-bottombar.scss \
  && echo -e "@import 'mastodon-no-more-sidebar/topbar';" >> /opt/mastodon/app/javascript/styles/contrast-topbar.scss \
  && echo -e "@import 'mastodon-no-more-sidebar/bottombar';" >> /opt/mastodon/app/javascript/styles/contrast-bottombar.scss \
  && echo -e "@import 'mastodon-no-more-sidebar/topbar';" >> /opt/mastodon/app/javascript/styles/mastodon-light-topbar.scss \
  && echo -e "@import 'mastodon-no-more-sidebar/bottombar';" >> /opt/mastodon/app/javascript/styles/mastodon-light-bottombar.scss \
  && echo -e "mastodon-dark-topbar: styles/mastodon-dark-topbar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "mastodon-dark-bottombar: styles/mastodon-dark-bottombar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "contrast-topbar: styles/contrast-topbar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "contrast-bottombar: styles/contrast-bottombar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "mastodon-light-topbar: styles/mastodon-light-topbar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "mastodon-light-bottombar: styles/mastodon-light-bottombar.scss" >> /opt/mastodon/config/themes.yml \
  && sed -i '/mastodon-light/a\    mastodon-dark-topbar: Mastodon (Dark Topbar)\n    mastodon-dark-bottombar: Mastodon (Dark Bottombar)\n    mastodon-contrast-topbar: Mastodon (High contrast Topbar)\n    mastodon-contrast-bottombar: Mastodon (High contrast Bottombar)\n    mastodon-light-topbar: Mastodon (Light Topbar)\n    mastodon-light-bottombar: Mastodon (Light Bottombar)' /opt/mastodon/config/locales/en.yml \
  && sed -i '/mastodon-light/a\    mastodon-dark-topbar: Mastodon（顶栏暗色主题）\n    mastodon-dark-bottombar: Mastodon（底栏暗色主题）\n    mastodon-contrast-topbar: Mastodon（顶栏高对比度）\n    mastodon-contrast-bottombar: Mastodon（底栏高对比度）\n    mastodon-light-topbar: Mastodon（顶栏亮色主题）\n    mastodon-light-bottombar: Mastodon（底栏亮色主题）' /opt/mastodon/config/locales/zh-CN.yml \
  && sed -i '/mastodon-light/a\    mastodon-dark-topbar: Mastodon（頂欄深色）\n    mastodon-dark-bottombar: Mastodon（底欄深色）\n    mastodon-contrast-topbar: Mastodon（頂欄高對比）\n    mastodon-contrast-bottombar: Mastodon（底欄高對比）\n    mastodon-light-topbar: Mastodon（頂欄亮色）\n    mastodon-light-bottombar: Mastodon（底欄亮色）' /opt/mastodon/config/locales/zh-TW.yml \
  && sed -i '/mastodon-light/a\    mastodon-dark-topbar: Mastodon（頂欄）\n    mastodon-dark-bottombar: Mastodon（底欄）\n    mastodon-contrast-topbar: Mastodon（頂欄高對比）\n    mastodon-contrast-bottombar: Mastodon（底欄高對比）\n    mastodon-light-topbar: Mastodon（頂欄亮色主題）\n    mastodon-light-bottombar: Mastodon（底欄亮色主題）' /opt/mastodon/config/locales/zh-HK.yml \
  && echo "加入 Mastodon (Sakura) 主题" \
  && sed -i "s|#6364FF|#f596aa|" /opt/mastodon/app/views/layouts/application.html.haml \
#  && sed -i "s|#191b22|#fedfe1|" /opt/mastodon/app/views/layouts/application.html.haml \
  && sed -i '/theme-color/d' /opt/mastodon/app/views/layouts/application.html.haml \
  && mkdir /opt/mastodon/app/javascript/styles/mastodon-sakura \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light/diff.scss /opt/mastodon/app/javascript/styles/mastodon-sakura/diff.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light/variables.scss /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#9baec8|#b5495b|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#d9e1e8|#fedfe1|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#6364ff|#f596aa|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#858afa|#eb7a77|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#b0c0cf|#feeeed|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && sed -i "s|#9bcbed|#f8c3cd|" /opt/mastodon/app/javascript/styles/mastodon-sakura/variables.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light.scss /opt/mastodon/app/javascript/styles/mastodon-sakura.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light-topbar.scss /opt/mastodon/app/javascript/styles/mastodon-sakura-topbar.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-light-bottombar.scss /opt/mastodon/app/javascript/styles/mastodon-sakura-bottombar.scss \
  && sed -i "s|light|sakura|" /opt/mastodon/app/javascript/styles/mastodon-sakura.scss \
  && sed -i "s|light|sakura|" /opt/mastodon/app/javascript/styles/mastodon-sakura-topbar.scss \
  && sed -i "s|light|sakura|" /opt/mastodon/app/javascript/styles/mastodon-sakura-bottombar.scss \
  && sed -i '/mastodon-light/a\    mastodon-sakura: Mastodon (Sakura)\n    mastodon-sakura-topbar: Mastodon (Sakura Topbar)\n    mastodon-sakura-bottombar: Mastodon (SakuraBottombar)' /opt/mastodon/config/locales/en.yml \
  && sed -i '/mastodon-light/a\    mastodon-sakura: Mastodon · 桜\n    mastodon-sakura-topbar: Mastodon · 桜（顶栏）\n    mastodon-sakura-bottombar: Mastodon · 桜（底栏）' /opt/mastodon/config/locales/zh-CN.yml \
  && sed -i '/mastodon-light/a\    mastodon-sakura: Mastodon · 桜\n    mastodon-sakura-topbar: Mastodon · 桜（頂欄）\n    mastodon-sakura-bottombar: Mastodon · 桜（底欄）' /opt/mastodon/config/locales/zh-TW.yml \
  && sed -i '/mastodon-light/a\    mastodon-sakura: Mastodon · 桜\n    mastodon-sakura-topbar: Mastodon · 桜（頂欄）\n    mastodon-sakura-bottombar: Mastodon · 桜（底欄）' /opt/mastodon/config/locales/zh-HK.yml \
  && echo -e "mastodon-sakura: styles/mastodon-sakura.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "mastodon-sakura-topbar: styles/mastodon-sakura-topbar.scss" >> /opt/mastodon/config/themes.yml \
  && echo -e "mastodon-sakura-bottombar: styles/mastodon-sakura-bottombar.scss" >> /opt/mastodon/config/themes.yml \
  && echo "加入 Mastodon Bird UI 主题" \
  && mkdir /opt/mastodon/app/javascript/styles/mastodon-bird-ui \
  && wget -nv https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/mastodon-4.1.2-stable/layout-single-column.css -O /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-single-column.scss \
  && wget -nv https://raw.githubusercontent.com/ronilaukkarinen/mastodon-bird-ui/mastodon-4.1.2-stable/layout-multiple-columns.css -O /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss \
  && sed -i 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-single-column.scss \
  && sed -i 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-single-column.scss \
  && sed -i 's/theme-contrast/theme-mastodon-bird-ui-contrast/g' /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss \
  && sed -i 's/theme-mastodon-light/theme-mastodon-bird-ui-light/g' /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss \
  && echo -e "@import 'application';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" > /opt/mastodon/app/javascript/styles/mastodon-bird-ui-dark.scss \
  && echo -e "@import 'mastodon-light/variables';\n@import 'application';\n@import 'mastodon-light/diff';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" > /opt/mastodon/app/javascript/styles/mastodon-bird-ui-light.scss \
  && echo -e "@import 'contrast/variables';\n@import 'application';\n@import 'contrast/diff';\n@import 'mastodon-bird-ui/layout-single-column.scss';\n@import 'mastodon-bird-ui/layout-multiple-columns.scss';" > /opt/mastodon/app/javascript/styles/mastodon-bird-ui-contrast.scss \
  && echo -e "mastodon-bird-ui-dark: styles/mastodon-bird-ui-dark.scss\nmastodon-bird-ui-contrast: styles/mastodon-bird-ui-contrast.scss\nmastodon-bird-ui-light: styles/mastodon-bird-ui-light.scss" >> /opt/mastodon/config/themes.yml \
  && sed -i '/mastodon-light/a\    mastodon-bird-ui-dark: Mastodon Bird UI (Dark)\n    mastodon-bird-ui-contrast: Mastodon Bird UI (High contrast)\n    mastodon-bird-ui-light: Mastodon Bird UI (Light)' /opt/mastodon/config/locales/en.yml \
  && sed -i '/mastodon-light/a\    mastodon-bird-ui-dark: Mastodon Bird UI（暗色主题）\n    mastodon-bird-ui-contrast: Mastodon Bird UI（高对比度）\n    mastodon-bird-ui-light: Mastodon Bird UI（亮色主题）' /opt/mastodon/config/locales/zh-CN.yml \
  && sed -i '/mastodon-light/a\    mastodon-bird-ui-dark: Mastodon Bird UI（深色）\n    mastodon-bird-ui-contrast: Mastodon Bird UI（高對比）\n    mastodon-bird-ui-light: Mastodon Bird UI（亮色）' /opt/mastodon/config/locales/zh-TW.yml \
  && sed -i '/mastodon-light/a\    mastodon-bird-ui-dark: Mastodon Bird UI\n    mastodon-bird-ui-contrast: Mastodon Bird UI（高對比）\n    mastodon-bird-ui-light: Mastodon Bird UI（亮色主題）' /opt/mastodon/config/locales/zh-HK.yml \
  && echo "加入 Mastodon Bird UI (Sakura) 主题" \
  && mkdir /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura \
  && cp /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-single-column.scss /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && cp /opt/mastodon/app/javascript/styles/mastodon-bird-ui/layout-multiple-columns.scss /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/light/sakura/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/light/sakura/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "/logo: url/a\  --logo: url\('data:image/png;base64,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'\);" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "/logo: url('data:image\/svg/d" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/595aff/f596aa/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/9388a6/828282/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/8c8dff/f4a7b9/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/e5e1ed/f7e6e7/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/17bf63/86C166/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/9588a6/0b1013/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/e6e1ed/fedfe1/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-single-column.scss \
  && sed -i "s/595aff/f596aa/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/9388a6/828282/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/8c8dff/f4a7b9/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/e5e1ed/f7e6e7/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/17bf63/86C166/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/9588a6/0b1013/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && sed -i "s/e6e1ed/fedfe1/g" /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura/layout-multiple-columns.scss \
  && echo -e "@import 'mastodon-sakura/variables';\n@import 'application';\n@import 'mastodon-sakura/diff';\n@import 'mastodon-bird-ui-sakura/layout-single-column.scss';\n@import 'mastodon-bird-ui-sakura/layout-multiple-columns.scss';" > /opt/mastodon/app/javascript/styles/mastodon-bird-ui-sakura.scss \
  && sed -i '/mastodon-sakura/a\    mastodon-bird-ui-sakura: Mastodon Bird UI (Sakura)' /opt/mastodon/config/locales/en.yml \
  && sed -i '/mastodon-sakura/a\    mastodon-bird-ui-sakura: Mastodon Bird UI · 桜' /opt/mastodon/config/locales/zh-CN.yml \
  && sed -i '/mastodon-sakura/a\    mastodon-bird-ui-sakura: Mastodon Bird UI · 桜' /opt/mastodon/config/locales/zh-TW.yml \
  && sed -i '/mastodon-sakura/a\    mastodon-bird-ui-sakura: Mastodon Bird UI · 桜' /opt/mastodon/config/locales/zh-HK.yml \
  && echo -e "mastodon-bird-ui-sakura: styles/mastodon-bird-ui-sakura.scss" >> /opt/mastodon/config/themes.yml \
  && echo "全文搜索中文优化" \
  && sed -i "s|whitespace|ik_max_word|" /opt/mastodon/app/chewy/accounts_index.rb \
  && sed -i "s|analyzer: {|char_filter: {\n      tsconvert: {\n        type: 'stconvert',\n        keep_both: false,\n        delimiter: '#',\n        convert_type: 't2s',\n      },\n    },\n    analyzer: {|" /opt/mastodon/app/chewy/statuses_index.rb \
  && sed -i "s|uax_url_email|ik_max_word|" /opt/mastodon/app/chewy/statuses_index.rb \
  && sed -i "s|        ),|        ),\n        char_filter: %w(tsconvert),|" /opt/mastodon/app/chewy/statuses_index.rb \
  && sed -i "s|analysis: {|analysis: {\n    char_filter: {\n      tsconvert: {\n        type: 'stconvert',\n        keep_both: false,\n        delimiter: '#',\n        convert_type: 't2s',\n      },\n    },|" /opt/mastodon/app/chewy/tags_index.rb \
  && sed -i "s|keyword',|ik_max_word',\n        char_filter: %w(tsconvert),|" /opt/mastodon/app/chewy/tags_index.rb \
  && echo "修改版本项目地址" \
  && sed -i "/def suffix/{n;s|''|'~wxw'|}" /opt/mastodon/lib/mastodon/version.rb \
  && sed -i "s|mastodon/mastodon|wxwmoe/mastodon|" /opt/mastodon/lib/mastodon/version.rb \
  && echo "重新编译资源文件" \
  && OTP_SECRET=precompile_placeholder SECRET_KEY_BASE=precompile_placeholder rails assets:precompile \
  && yarn cache clean
