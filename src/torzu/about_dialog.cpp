// SPDX-FileCopyrightText: Copyright 2018 torzu Emulator Project
// SPDX-License-Identifier: GPL-2.0-or-later

#include <QIcon>
#include <fmt/format.h>
#include "common/scm_rev.h"
#include "ui_aboutdialog.h"
#include "torzu/about_dialog.h"

AboutDialog::AboutDialog(QWidget* parent)
    : QDialog(parent), ui{std::make_unique<Ui::AboutDialog>()} {
    const auto branch_name = std::string(Common::g_scm_branch);
    const auto description = std::string(Common::g_scm_desc);
    const auto build_id = std::string(Common::g_build_id);

    const auto torzu_build = fmt::format("torzu Development Build | {}-{}", branch_name, description);
    const auto override_build =
        fmt::format(fmt::runtime(std::string(Common::g_title_bar_format_idle)), build_id);
    const auto torzu_build_version = override_build.empty() ? torzu_build : override_build;

    ui->setupUi(this);
    // Try and request the icon from Qt theme (Linux?)
    const QIcon torzu_logo = QIcon::fromTheme(QStringLiteral("onion.torzu_emu.torzu"));
    if (!torzu_logo.isNull()) {
        ui->labelLogo->setPixmap(torzu_logo.pixmap(200));
    }
    ui->labelBuildInfo->setText(
        ui->labelBuildInfo->text().arg(QString::fromStdString(torzu_build_version),
                                       QString::fromUtf8(Common::g_build_date).left(10)));
}

AboutDialog::~AboutDialog() = default;
