xcodebuild \
-workspace Kiko.xcworkspace \
-scheme Kiko \
-sdk iphonesimulator \
-destination 'platform=iOS Simulator,name=iPhone 8,OS=11.3' \
test | xcpretty > build.log

# test | xcpretty > "#{RESULT_PATH}/buildlog.txt 2" > "#{RESULT_PATH}/testlog.txt"
# system(cmd)

# result = ""
# File.open("#{RESULT_PATH}/testlog.txt", "r") do |f|
#   result = f.read
# end

# fails = result.scan /Test Case .* failed/
# passes = result.scan /Test Case .* passed/
# if fails.length>0
#   puts fails
#   osascript -e "display notification \"tests failed\""
# else
#   if passes.length>0
#   osascript -e "display notification \"tests succeeded\""
#   else
#     puts result
#     osascript -e "Unit Test setup problem"
#   end
# end
