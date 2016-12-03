<?php

namespace AppBundle\Service;


use CacheBundle\Annotation\Cache;
use Symfony\Component\HttpFoundation\Request;
use Whois;

class IpInfo
{
    /** @var  Whois */
    protected $whois;

    public function setWhoisService(Whois $whois)
    {
        $this->whois = $whois;
    }

    /**
     * @param Request $req
     * @return array
     */
    public function getData(Request $req): array
    {
        $ip = $req->getClientIp();
        return [
            'ip' => $req->getClientIp(),
            'locale' => $req->getLocale(),
            'provider' => $this->getProvider($ip)
        ];
    }

    /**
     * @param $ip
     * @return mixed
     */
    protected function getProvider($ip)
    {
        try {
            return $this->lookup($ip)['regrinfo']['owner']['organization'][0];

        } catch (\Throwable $e) {
            var_dump($e);
            return 'Unkown';
        }
    }

    /**
     * @param $ip
     * @Cache(cache="lookup_ip", key="ip", ttl="3600")
     * @return array
     */
    protected function lookup($ip): array
    {
        return $this->whois->lookup($ip);
    }
}