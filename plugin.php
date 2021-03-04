<?php
/**
 * Plugin Name:     ClassicalU ACG Files
 * Plugin URI:      https://github.com/classicalacademicpress/classicalu-acg-files
 * Description:     A plugin to embed Ambrose curriculum files.
 * Author:          Classical Academic Press
 * Author URI:      https://classicalacademicpress.com
 * Version:         1.0.0
 *
 */

declare(strict_types=1);

$file = plugin_basename(__FILE__);

add_filter("plugin_action_links_" . $file, function (array $actions): array {
    $url = "https://github.com/classicalacademicpress/classicalu-acg-files";

    $links = ["<a href=\"{$url}\" target=\"_blank\">View Documentation</a>"];

    return array_merge($actions, $links);
});

add_shortcode("acg_file", function (array $atts): string {
    if (!empty($atts["src"])) {
        $css = plugins_url("assets/css/main.css", __FILE__);
        $elm = plugins_url("assets/dist/elm.js", __FILE__);
        $js = plugins_url("assets/dist/main.js", __FILE__);

        wp_enqueue_style("acg-file-main", $css);
        wp_enqueue_script("acg-file-elm", $elm, [], 1.0, true);
        wp_enqueue_script("acg-file-main", $js, ["acg-file-elm"], 1.0, true);

        $data = [
            "height" => (int) $atts["height"] ?: 600,
            "width" => (int) $atts["width"] ?: 800,
            "src" => (string) $atts["src"],
        ];

        ob_start();

        $flags = htmlspecialchars(json_encode($data), ENT_QUOTES, "UTF-8");

        require implode("/", [__DIR__, "views", "acg-file.php"]);

        return ob_get_clean();
    } else {
        return "Please enter a <pre>src</pre> attribute.";
    }
});
