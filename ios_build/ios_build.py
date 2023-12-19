import subprocess
import os
import time


# 指定证书标识符和配置文件 UUID
CODE_SIGN_IDENTITY = ""
PROVISIONING_PROFILE = ""

OUTPUT_ROOT_PATH = "*****" + time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()) + "/" #输出文件的路径
ARCHIVE_PATH = OUTPUT_ROOT_PATH + "****.xcarchive"  # archive路径

# 运行 xcodebuild 命令进行打包
def build_app():

    project_path = "****/***.xcworkspace"  # 项目路径 
    scheme = "****"  #项目scheme名称
    configuration = "Release"  # 打包配置 Debug/Release
    
    build_command = [
        "xcodebuild","archive", "-workspace", project_path, "-scheme", scheme,
        "-configuration", configuration, "archive", "-archivePath", ARCHIVE_PATH,  
        # f"CODE_SIGN_IDENTITY={CODE_SIGN_IDENTITY}",
        # f"PROVISIONING_PROFILE={PROVISIONING_PROFILE}"
    ]

    # 执行命令
    subprocess.run(build_command)

# 运行 xcodebuild 命令导出 ipa 文件
def export_ipa():
    output_path = OUTPUT_ROOT_PATH+"ipa"  # 输出文件夹路径
    export_options_path = os.getcwd()+"/ExportOptions_adhoc.plist"  # 自己的plist

    # 导出命令
    export_command = [
        "xcodebuild", "-exportArchive", "-archivePath", ARCHIVE_PATH,
        "-exportOptionsPlist", export_options_path, "-exportPath", output_path
    ]

    # 执行命令
    subprocess.run(export_command)

# 主函数，按顺序执行打包步骤
def main():

    build_app()
    export_ipa()
    print("输出目录" + OUTPUT_ROOT_PATH);


# 执行主函数
main()
